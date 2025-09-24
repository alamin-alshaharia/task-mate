import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/screens/note_screens/note_detail_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:get/get.dart';

import '../../controller/note_controller.dart';

class Search extends SearchDelegate {
  final NoteController controller = Get.find<NoteController>();

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: LightColors.primaryBlue,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
          color: Colors.white70,
          fontSize: 18,
        ),
        border: InputBorder.none,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Container(
        margin: const EdgeInsets.only(right: 8),
        child: IconButton(
          onPressed: () {
            query = "";
          },
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const Icon(Icons.clear_rounded, color: Colors.white),
        ),
      ),
    ];
  }

  @override
  String get searchFieldLabel => 'Search your notes...';

  @override
  Widget buildLeading(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: IconButton(
        onPressed: () {
          Get.back();
        },
        style: IconButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? controller.notes
        : controller.notes.where(
            (p) {
              return p.title!.toLowerCase().contains(query.toLowerCase()) ||
                  p.content!.toLowerCase().contains(query.toLowerCase());
            },
          ).toList();

    if (suggestionList.isEmpty) {
      return _buildEmptySearchState();
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            LightColors.backgroundColor,
            Color(0xFFF1F5F9),
          ],
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          final note = suggestionList[index];
          final gradient = LightColors.getCardGradient(index);
          final accentColor = LightColors.getCardAccentColor(index);

          return _buildSearchResultCard(
            note: note,
            index: index,
            gradient: gradient,
            accentColor: accentColor,
            originalIndex: controller.notes.indexOf(note),
          );
        },
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            LightColors.backgroundColor,
            Color(0xFFF1F5F9),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LightColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: LightColors.primaryBlue.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "No notes found",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: LightColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              query.isEmpty
                  ? "Start typing to search your notes"
                  : "Try different keywords",
              style: const TextStyle(
                fontSize: 16,
                color: LightColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultCard({
    required dynamic note,
    required int index,
    required LinearGradient gradient,
    required Color accentColor,
    required int originalIndex,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          ),
        ],
        border: Border.all(
          color: accentColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Get.to(NoteDetailPage(), arguments: originalIndex);
          },
          child: Column(
            children: [
              // Gradient accent bar
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with search highlight
                    _buildHighlightedText(
                      text: note.title!,
                      query: query,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: LightColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                      highlightColor: accentColor,
                    ),
                    const SizedBox(height: 12),

                    // Content with search highlight
                    _buildHighlightedText(
                      text: note.content!,
                      query: query,
                      style: const TextStyle(
                        fontSize: 15,
                        color: LightColors.textSecondary,
                        height: 1.5,
                      ),
                      highlightColor: accentColor,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Date badge
                    Row(
                      children: [
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedText({
    required String text,
    required String query,
    required TextStyle style,
    required Color highlightColor,
    int? maxLines,
  }) {
    if (query.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];

    int start = 0;
    int index = lowerText.indexOf(lowerQuery);

    while (index >= 0) {
      // Add text before match
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: style,
        ));
      }

      // Add highlighted match
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: style.copyWith(
          backgroundColor: highlightColor.withOpacity(0.3),
          fontWeight: FontWeight.bold,
          color: highlightColor,
        ),
      ));

      start = index + query.length;
      index = lowerText.indexOf(lowerQuery, start);
    }

    // Add remaining text
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: style,
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.visible,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Use the same as suggestions for consistency
    return buildSuggestions(context);
  }
}
