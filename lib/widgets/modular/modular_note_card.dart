import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/note_controller.dart';
import '../../screens/note_screens/note_detail_page.dart';
import '../../theme/colors/light_colors.dart';
import '../../widgets/common/delete_confirmation_dialog.dart';

class ModularNoteCard extends StatelessWidget {
  final dynamic note;
  final int index;
  final NoteController controller;

  const ModularNoteCard({
    super.key,
    required this.note,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = LightColors.getCardGradient(index);
    final accentColor = LightColors.getCardAccentColor(index);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        // Clamp the value to ensure it's between 0.0 and 1.0
        final clampedValue = value.clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, 30 * (1 - clampedValue)),
          child: Opacity(
            opacity: clampedValue,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Get.to(NoteDetailPage(), arguments: index);
                  },
                  onLongPress: () {
                    DeleteConfirmationDialog.showNoteDeleteDialog(
                      context: context,
                      noteTitle: note.title ?? '',
                      onConfirm: () {
                        controller.deleteNote(note.id!);
                        Get.back();
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          gradient.colors.first.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.7),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                          spreadRadius: 0,
                        ),
                      ],
                      border: Border.all(
                        color: accentColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Enhanced gradient accent bar
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            gradient: gradient,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Enhanced title
                                    Text(
                                      note.title!,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: LightColors.textPrimary,
                                        letterSpacing: -0.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 12),

                                    // Enhanced content preview
                                    Text(
                                      note.content!,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: LightColors.textSecondary,
                                        height: 1.5,
                                        letterSpacing: 0.1,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 16),

                                    // Enhanced date badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            accentColor.withOpacity(0.1),
                                            accentColor.withOpacity(0.05),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: accentColor.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.schedule_rounded,
                                            size: 14,
                                            color: accentColor,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            note.dateTimeEdited!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: accentColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),

                              // Enhanced favorite button
                              GetBuilder<NoteController>(
                                id: 'favorite_${note.id}',
                                builder: (_) => ModularFavoriteButton(
                                  isFavorite: note.isFavorite == true,
                                  onPressed: () {
                                    controller.favoriteNote(note.id!);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

class ModularFavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onPressed;

  const ModularFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
  });

  @override
  State<ModularFavoriteButton> createState() => _ModularFavoriteButtonState();
}

class _ModularFavoriteButtonState extends State<ModularFavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(ModularFavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger animation when favorite state changes
    if (oldWidget.isFavorite != widget.isFavorite) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_scaleAnimation.value - 1.0) * 0.3,
          child: Container(
            decoration: BoxDecoration(
              gradient: widget.isFavorite
                  ? LightColors.redGradient
                  : LinearGradient(
                      colors: [
                        Colors.grey.shade100,
                        Colors.grey.shade50,
                      ],
                    ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.isFavorite
                    ? Colors.red.shade200
                    : Colors.grey.shade200,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.isFavorite
                      ? Colors.red
                          .withOpacity(0.3 + (_pulseAnimation.value * 0.2))
                      : Colors.grey.withOpacity(0.1),
                  blurRadius: 8 + (_pulseAnimation.value * 4),
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // Trigger animation on tap
                  _animationController.forward().then((_) {
                    _animationController.reverse();
                  });

                  // Call the actual function
                  widget.onPressed();
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: Icon(
                      widget.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      key: ValueKey(widget.isFavorite),
                      color: widget.isFavorite
                          ? Colors.white
                          : Colors.grey.shade400,
                      size: 22,
                    ),
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
