class SeatLayoutModel {
  final int rows;
  final int cols;
  final List<String> seatTypes;
  final int theatreId;
  final int gap;
  final int gapColIndex;

  SeatLayoutModel({
    required this.rows,
    required this.cols,
    required this.seatTypes,
    required this.theatreId,
    required this.gap,
    required this.gapColIndex,
  });

  SeatLayoutModel copyWith({
    int? rows,
    int? cols,
    List<String>? seatTypes,
    int? theatreId,
    int? gap,
    int? gapColIndex,
  }) {
    return SeatLayoutModel(
      rows: rows ?? this.rows,
      cols: cols ?? this.cols,
      seatTypes: seatTypes ?? this.seatTypes,
      theatreId: theatreId ?? this.theatreId,
      gap: gap ?? this.gap,
      gapColIndex: gapColIndex ?? this.gapColIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rows': rows,
      'cols': cols,
      'seatTypes': seatTypes,
      'theatreId': theatreId,
      'gap': gap,
      'gapColIndex': gapColIndex,

    };
  }
}
