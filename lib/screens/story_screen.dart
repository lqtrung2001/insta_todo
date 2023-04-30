import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_todo/models/story.dart';
import 'package:insta_todo/models/story.dart' as modelStory;
import 'package:insta_todo/screens/feed_screen.dart';

class StoryScreen extends StatefulWidget {
  final List<Story> stories;
  final fullSnap, index, lengthSnap;

  const StoryScreen({required this.stories, required this.fullSnap, required this.index, required this.lengthSnap});

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animController;
  int _currentIndex = 0;
  late int _indexPage = widget.index;
  late String key = widget.fullSnap.keys.elementAt(_indexPage);
  List<Story> _stories = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(vsync: this);

    widget.fullSnap[key].forEach((element)  {
      _stories.add(modelStory.Story.fromSnap(element));
    });

    _loadStory(story: _stories[_currentIndex], animateToPage: false);

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animController.stop();
        _animController.reset();
        setState(() {
          if (_currentIndex + 1 < _stories.length) {
            _currentIndex += 1;
            _loadStory(story: _stories[_currentIndex], animateToPage: false);
          } else {
            // Out of bounds - loop story
            // You can also Navigator.of(context).pop() here
            _indexPage += 1;
            if (_indexPage < widget.lengthSnap) {
              key = widget.fullSnap.keys.elementAt(_indexPage);
              _stories = [];
              widget.fullSnap[key].forEach((element)  {
                _stories.add(modelStory.Story.fromSnap(element));
              });
              _currentIndex = 0;
              _loadStory(story: _stories[_currentIndex], animateToPage: true);
            } else {
              Navigator.pop(context);
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    key = widget.fullSnap.keys.elementAt(_indexPage);
    _stories = [];
    widget.fullSnap[key].forEach((element)  {
      _stories.add(modelStory.Story.fromSnap(element));
    });
    final Story story = _stories[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => _onTapDown(details, story),
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.stories.length,
              itemBuilder: (context, i) {
                final Story story = widget.stories[i];
                    return CachedNetworkImage(
                      imageUrl: story.postUrl,
                      fit: BoxFit.cover,
                    );
              },
            ),
            Positioned(
              top: 40.0,
              left: 10.0,
              right: 10.0,
              child: Column(
                children: <Widget>[
                  Row(
                    children: widget.stories
                        .asMap()
                        .map((i, e) {
                      return MapEntry(
                        i,
                        AnimatedBar(
                          animController: _animController,
                          position: i,
                          currentIndex: _currentIndex,
                        ),
                      );
                    })
                        .values
                        .toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 1.5,
                      vertical: 10.0,
                    ),
                    child: _showUserInfo(story.profImage, story.username),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showUserInfo(String profileImageUrl, String username) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.grey[300],
          backgroundImage: CachedNetworkImageProvider(
            profileImageUrl,
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(
            username,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.close,
            size: 30.0,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  void _onTapDown(TapDownDetails details, Story story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      setState(() {
        if (_currentIndex - 1 >= 0) {
          _currentIndex -= 1;
          _loadStory(story: _stories[_currentIndex], animateToPage: false);
        } else {
          // Out of bounds - loop story
          // You can also Navigator.of(context).pop() here
          _indexPage -= 1;
          if (_indexPage >= 0) {
            key = widget.fullSnap.keys.elementAt(_indexPage);
            _stories = [];
            widget.fullSnap[key].forEach((element)  {
              _stories.add(modelStory.Story.fromSnap(element));
            });
            _currentIndex = _stories.length;
            _loadStory(story: _stories[_currentIndex], animateToPage: true);
          } else {
            Navigator.pop(context);
          }
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (_currentIndex + 1 < _stories.length) {
          _currentIndex += 1;
          _loadStory(story: _stories[_currentIndex], animateToPage: false);
        } else {
          // Out of bounds - loop story
          // You can also Navigator.of(context).pop() here
          _indexPage += 1;
          if (_indexPage < widget.lengthSnap) {
            key = widget.fullSnap.keys.elementAt(_indexPage);
            _stories = [];
            widget.fullSnap[key].forEach((element)  {
              _stories.add(modelStory.Story.fromSnap(element));
            });
            _currentIndex = 0;
            _loadStory(story: _stories[_currentIndex], animateToPage: true);
          } else {
            Navigator.pop(context);
          }
        }
      });
    }
  }

  void _loadStory({Story? story, bool animateToPage = true}) {
    _animController.stop();
    _animController.reset();
    _animController.duration = const Duration(seconds: 10);
    _animController.forward();

    if (animateToPage) {
      if(_pageController.hasClients) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    StoryScreen(stories: _stories, fullSnap: widget.fullSnap, index: _indexPage, lengthSnap: widget.lengthSnap,),
                    )
        );
      }
    }
  }
}

class AnimatedBar extends StatelessWidget {
  final AnimationController animController;
  final int position;
  final int currentIndex;

  const AnimatedBar({
    Key? key,
    required this.animController,
    required this.position,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                _buildContainer(
                  double.infinity,
                  position < currentIndex
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
                position == currentIndex
                    ? AnimatedBuilder(
                  animation: animController,
                  builder: (context, child) {
                    return _buildContainer(
                      constraints.maxWidth * animController.value,
                      Colors.white,
                    );
                  },
                )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _buildContainer(double width, Color color) {
    return Container(
      height: 5.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black26,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
  }
}
