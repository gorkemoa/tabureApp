import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/user.dart';
import '../../models/swipe.dart';

class UserCard extends StatefulWidget {
  final User user;
  final Function(SwipeAction) onSwipe;

  const UserCard({
    super.key,
    required this.user,
    required this.onSwipe,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;
  
  Offset _cardOffset = Offset.zero;
  double _cardRotation = 0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(_animationController);
    
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _cardOffset += details.delta;
      _cardRotation = _cardOffset.dx / 10;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });

    if (_cardOffset.dx.abs() > 100) {
      // Swipe detected
      final action = _cardOffset.dx > 0 ? SwipeAction.like : SwipeAction.pass;
      _animateCardOut(action);
    } else {
      // Snap back
      _animateCardBack();
    }
  }

  void _animateCardOut(SwipeAction action) {
    final endOffset = Offset(
      _cardOffset.dx > 0 ? 400 : -400,
      _cardOffset.dy,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: _cardOffset,
      end: endOffset,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: _cardRotation,
      end: _cardRotation * 2,
    ).animate(_animationController);

    _animationController.forward().then((_) {
      widget.onSwipe(action);
      _resetCard();
    });
  }

  void _animateCardBack() {
    _slideAnimation = Tween<Offset>(
      begin: _cardOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: _cardRotation,
      end: 0,
    ).animate(_animationController);

    _animationController.forward().then((_) {
      _resetCard();
    });
  }

  void _resetCard() {
    _animationController.reset();
    setState(() {
      _cardOffset = Offset.zero;
      _cardRotation = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final offset = _animationController.isAnimating
            ? _slideAnimation.value
            : _cardOffset;
        final rotation = _animationController.isAnimating
            ? _rotationAnimation.value
            : _cardRotation;

        return Transform.translate(
          offset: offset,
          child: Transform.rotate(
            angle: rotation * 0.01,
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Profile image
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: widget.user.profilePhotoUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      
                      // Gradient overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                              stops: const [0.0, 0.6, 1.0],
                            ),
                          ),
                        ),
                      ),
                      
                      // User information
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.user.fullName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (widget.user.isVerified)
                                    const Icon(
                                      Icons.verified,
                                      color: Colors.blue,
                                      size: 24,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.user.profession} @ ${widget.user.company}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.white.withOpacity(0.8),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.user.city,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(
                                    Icons.work,
                                    color: Colors.white.withOpacity(0.8),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.user.experienceLevel,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.user.lookingFor,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: widget.user.skills.take(3).map((skill) => 
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      skill,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Swipe indicators
                      if (_isDragging)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: _cardOffset.dx > 50
                                  ? Colors.green.withOpacity(0.3)
                                  : _cardOffset.dx < -50
                                      ? Colors.red.withOpacity(0.3)
                                      : Colors.transparent,
                            ),
                            child: Center(
                              child: _cardOffset.dx > 50
                                  ? const Icon(
                                      Icons.favorite,
                                      size: 100,
                                      color: Colors.green,
                                    )
                                  : _cardOffset.dx < -50
                                      ? const Icon(
                                          Icons.close,
                                          size: 100,
                                          color: Colors.red,
                                        )
                                      : null,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
