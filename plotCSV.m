function plotCSV()

fc = 800e6;

files = {
    'results/results-noc-tx.txt'
    'results/results-meta-tx.txt'
};

clf; hold on;

makePDF = 1;

delays_cyc = [];

for i=1:2
    
    dat = csvread(files{i});
    
    n = size(dat, 1);
    
    k = length(unique(dat(:, 2)));
    
    m = reshape(dat, [k n/k 3]);
    
    rates = m(1, :, 1) / 65536;
    
    d = mean(m(:, :, 3));
    
    delays_cyc = [delays_cyc; d];
    
end

delays_us = delays_cyc / fc / 1e-6;

hold on

plot(rates, delays_us(1, :), '-o');
plot(rates, delays_us(2, :), '-s', 'color', [0 0.5 0]);

xlabel('Packet Injection Rate');

ylabel('Mean Packet Delivery Time (usec)');

set(gca, 'xscale', 'log');

ylim([0 0.8]);

grid on; box on;

legend({'noc', 'metanoc'});

if makePDF == 1
    
    makeLines1pt();
    
    ppdf2('d:\fig_performance.pdf', [8.8 5.5]);
    
end

end