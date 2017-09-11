n = [748  2252         0    1497000;
2680   320         0    1497000;
2921    79         9    1496991;
2981    19      1208    1495792;
2994     6      6472    1490528;
3000     0     71496    1425504;
3000     0    321615    1175385;
3000     0   1439137      57863;
3000     0   1497000          0;
3000     0   1497000          0;
3000     0   1497000          0;
3000     0   1497000          0;
3000     0   1497000          0];

tp = n(:, 1) ./ (n(:, 1) + n(:, 3));
fp = n(:, 3) ./ (n(:, 1) + n(:, 3));
fn = n(:, 2) ./ (n(:, 2) + n(:, 4));
tn = n(:, 4) ./ (n(:, 2) + n(:, 4));

error = [0.2 0.25 0.27 0.29 0.3 0.32 0.34 0.4 0.5 0.6 0.7 0.8 0.9];

figure, plot([0, error], [1; fn], 'r', [0, error], [0; fp], 'b')

tann = [error', tp, fn, fp, tn]
