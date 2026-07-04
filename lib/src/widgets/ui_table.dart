import 'package:flutter/material.dart';
import '../tokens/ui_typography.dart';

class UITableColumn {
  final String label;
  final Alignment alignment;

  const UITableColumn({
    required this.label,
    this.alignment = Alignment.centerLeft,
  });
}

class UITableCell {
  final String text;
  final bool isNumeric;
  final TextStyle? style;

  const UITableCell(
    this.text, {
    this.isNumeric = false,
    this.style,
  });
}

class UITableRow {
  final List<UITableCell> cells;

  const UITableRow({required this.cells});
}

/// A highly polished, reusable Material 3 Table widget with support for
/// tabular figures formatting on numeric cells.
class UITable extends StatelessWidget {
  final List<UITableColumn> columns;
  final List<UITableRow> rows;
  final double columnSpacing;
  final double horizontalMargin;

  const UITable({
    super.key,
    required this.columns,
    required this.rows,
    this.columnSpacing = 24.0,
    this.horizontalMargin = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.black12,
            width: 1.0,
          ),
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        ),
        child: DataTable(
          columnSpacing: columnSpacing,
          horizontalMargin: horizontalMargin,
          headingRowColor: WidgetStateProperty.all(
            isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF4F6F6),
          ),
          headingTextStyle: UITypography.labelMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          dataRowMinHeight: 48.0,
          dataRowMaxHeight: 48.0,
          headingRowHeight: 44.0,
          dividerThickness: 1.0,
          columns: columns.map((col) {
            return DataColumn(
              label: Container(
                alignment: col.alignment,
                child: Text(
                  col.label,
                  textAlign: col.alignment == Alignment.centerRight
                      ? TextAlign.right
                      : col.alignment == Alignment.center
                          ? TextAlign.center
                          : TextAlign.left,
                ),
              ),
            );
          }).toList(),
          rows: rows.map((row) {
            return DataRow(
              cells: row.cells.asMap().entries.map((entry) {
                final idx = entry.key;
                final cell = entry.value;
                final alignment = idx < columns.length
                    ? columns[idx].alignment
                    : Alignment.centerLeft;

                final textStyle = (cell.style ??
                        UITypography.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface,
                        ))
                    .copyWith(
                  fontFeatures: cell.isNumeric
                      ? const [FontFeature.tabularFigures()]
                      : null,
                );

                return DataCell(
                  Container(
                    alignment: alignment,
                    child: Text(
                      cell.text,
                      style: textStyle,
                      textAlign: alignment == Alignment.centerRight
                          ? TextAlign.right
                          : alignment == Alignment.center
                              ? TextAlign.center
                              : TextAlign.left,
                    ),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }
}
