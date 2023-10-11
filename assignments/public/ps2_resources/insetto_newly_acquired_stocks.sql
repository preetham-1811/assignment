insert into newly_acquired_stocks (symbol, n_shares, date_acquired) select symbol, n_shares, date_acquired from my_stocks limit 3;
