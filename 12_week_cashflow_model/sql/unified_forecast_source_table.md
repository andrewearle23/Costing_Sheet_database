CREATE OR REPLACE VIEW cashflow_forecast_events AS
(
    -- Cash Outflow - Deposit
    SELECT
        dco.deal_no,
        'Outflow' AS type,
        dco.deposit_date AS forecast_date,
        dco.total_cost * dco.deposit_pct AS amount
    FROM deal_cash_outflow dco

    UNION ALL

    -- Cash Outflow - Balance
    SELECT
        dco.deal_no,
        'Outflow',
        dco.balance_date,
        dco.total_cost * dco.balance_pct
    FROM deal_cash_outflow dco

    UNION ALL

    -- Cash Inflow - Deposit
    SELECT
        dci.deal_no,
        'Inflow',
        dci.deposit_date,
        dci.total_sales * dci.deposit_pct
    FROM deal_cash_inflow dci

    UNION ALL

    -- Cash Inflow - Balance (expected payment)
    SELECT
        dci.deal_no,
        'Inflow',
        DATE_ADD(
            dci.uplift_start,
            INTERVAL (dci.uplift_days + dci.travel_days + dci.terms_days) DAY
        ),
        dci.total_sales * dci.balance_pct
    FROM deal_cash_inflow dci
);
