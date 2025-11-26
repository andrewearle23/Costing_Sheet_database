# DAX Measures (Complete Package)

## Index
- Cashflow Measures
- Weekly Cashflow Breakdown
- Rolling Balance Engine
- Matrix Selector
- Deal Timeline Measures
- Profitability Measures

## Cashflow Measures
```DAX
Total Inflow :=
CALCULATE(
    SUM(cashflow_12week[weekly_amount]),
    cashflow_12week[type] = "Inflow"
)

Total Outflow :=
CALCULATE(
    SUM(cashflow_12week[weekly_amount]),
    cashflow_12week[type] = "Outflow"
)

Net Cash :=
[Total Inflow] + [Total Outflow]

Worst Weekly Net Cash :=
MINX(
    VALUES(cashflow_12week[week_start]),
    CALCULATE([Net Cash])
)

Best Weekly Net Cash :=
MAXX(
    VALUES(cashflow_12week[week_start]),
    CALCULATE([Net Cash])
)

Active Deals :=
DISTINCTCOUNT(cashflow_12week[deal_no])
```

## Weekly Cashflow Breakdown
```DAX
Weekly Inflow :=
CALCULATE(
    SUM('cashflow_12week'[weekly_amount]),
    'cashflow_12week'[type] = "Inflow"
)

Weekly Outflow :=
CALCULATE(
    SUM('cashflow_12week'[weekly_amount]),
    'cashflow_12week'[type] = "Outflow"
)

Net Cash Calc :=
[Weekly Inflow] + [Weekly Outflow]

Starting Balance := 0

Weekly Interest Rate := 0.12 / 52
```

## Rolling Balance Engine (Recursive-safe)
```DAX
Closing Balance :=
VAR ThisWeek = MAX('Calendar'[WeekStart])
VAR WeeksTable =
    FILTER(
        ALL('Calendar'),
        'Calendar'[WeekStart] <= ThisWeek
    )
VAR Result =
    SUMX(
        WeeksTable,
        VAR WeekStart = 'Calendar'[WeekStart]
        VAR PrevWeek =
            CALCULATE(
                MAX('Calendar'[WeekStart]),
                FILTER(
                    ALL('Calendar'),
                    'Calendar'[WeekStart] < WeekStart
                )
            )
        VAR Opening =
            IF(
                WeekStart = MINX(WeeksTable,'Calendar'[WeekStart]),
                [Starting Balance],
                CALCULATE(
                    [Closing Balance],
                    'Calendar'[WeekStart] = PrevWeek
                )
            )
        VAR Cash =
            CALCULATE(
                [Net Cash Calc],
                'Calendar'[WeekStart] = WeekStart
            )
        VAR Rate = 0.12 / 52
        VAR FinCost =
            IF(Opening < 0, ABS(Opening) * Rate, 0)
        RETURN Opening + Cash - FinCost
    )
RETURN Result
```

```DAX
Opening Balance :=
VAR ThisWeek = MAX('Calendar'[WeekStart])
VAR PrevWeek =
    CALCULATE(
        MAX('Calendar'[WeekStart]),
        FILTER(
            ALL('Calendar'),
            'Calendar'[WeekStart] < ThisWeek
        )
    )
RETURN
IF(
    ISBLANK(PrevWeek),
    [Starting Balance],
    CALCULATE(
        [Closing Balance],
        'Calendar'[WeekStart] = PrevWeek
    )
)
```

```DAX
Finance Cost :=
VAR Opening = [Opening Balance]
VAR Rate = 0.12 / 52
RETURN IF(Opening < 0, ABS(Opening) * Rate, 0)
```

## Matrix Value Selector
```DAX
Cashflow Matrix Value :=
SWITCH(
    SELECTEDVALUE('Cashflow Rows'[Row]),
    "Opening Balance", [Opening Balance],
    "Inflows", [Weekly Inflow],
    "Outflows", [Weekly Outflow],
    "Net Cash", [Net Cash Calc],
    "Finance Cost", [Finance Cost],
    "Closing Balance", [Closing Balance]
)
```

## Deal Timeline Measures
```DAX
Days to Close :=
VAR CreatedDate = MIN('Deal'[date_created])
VAR ClosedDate = MIN('Deal'[date_closed])
RETURN IF(NOT ISBLANK(CreatedDate) && NOT ISBLANK(ClosedDate),
    DATEDIFF(CreatedDate, ClosedDate, DAY)
)

Days to Quote :=
VAR CreatedDate = MIN('Deal'[date_created])
VAR QuoteDate = MIN('Deal'[quote_submitted])
RETURN IF(NOT ISBLANK(CreatedDate) && NOT ISBLANK(QuoteDate),
    DATEDIFF(CreatedDate, QuoteDate, DAY)
)

Days to Win :=
VAR QuoteDate = MIN('Deal'[quote_submitted])
VAR ClosedDate = MIN('Deal'[date_closed])
RETURN IF(NOT ISBLANK(QuoteDate) && NOT ISBLANK(ClosedDate),
    DATEDIFF(QuoteDate, ClosedDate, DAY)
)

Average Days to Close :=
AVERAGEX(VALUES('Deal'[deal_no]), [Days to Close])

Average Days to Quote :=
AVERAGEX(VALUES('Deal'[deal_no]), [Days to Quote])

Average Days to Win :=
AVERAGEX(VALUES('Deal'[deal_no]), [Days to Win])
```

## Profitability Measures
```DAX
Total Sales :=
SUM('Deal'[sales_total])

Total Gross Profit :=
SUM('Deal'[gross_profit])

Total Profit After FC :=
SUM('Deal'[profit_after_fc])

GP % :=
DIVIDE([Total Gross Profit], [Total Sales])

Profit After FC % :=
DIVIDE([Total Profit After FC], [Total Sales])
```
