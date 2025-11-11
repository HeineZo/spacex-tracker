import 'package:flutter/material.dart';

class ViewModeToggle<T extends Enum> extends StatelessWidget {
  final T selectedMode;
  final T gridMode;
  final T listMode;
  final ValueChanged<T> onModeChanged;
  final EdgeInsets? padding;

  const ViewModeToggle({
    super.key,
    required this.selectedMode,
    required this.gridMode,
    required this.listMode,
    required this.onModeChanged,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
      child: SegmentedButton<T>(
        segments: [
          ButtonSegment(
            value: gridMode,
            icon: const Icon(Icons.grid_view),
          ),
          ButtonSegment(
            value: listMode,
            icon: const Icon(Icons.list),
          ),
        ],
        selected: {selectedMode},
        showSelectedIcon: false,
        onSelectionChanged: (set) => onModeChanged(set.first),
      ),
    );
  }
}

