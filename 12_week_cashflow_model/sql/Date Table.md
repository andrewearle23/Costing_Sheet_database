Calendar =
ADDCOLUMNS (
    CALENDAR ( TODAY(), TODAY() + 84 ),
    "WeekStart", [Date] - WEEKDAY([Date], 2) + 1,
    "WeekNum", WEEKNUM([Date], 2),
    "YearWeek", FORMAT([Date], "YYYY") & FORMAT(WEEKNUM([Date],2), "00")
)