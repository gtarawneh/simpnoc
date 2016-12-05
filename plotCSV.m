function plotCSV()

files = {'results-noc-tx.txt' 'results-meta-tx.txt'};

styles = {'-r^', '-b^'};

figure(); clf; hold on;

for i=1:2
    
    dat = csvread(files{i});
    
    n = size(dat, 1);
    
    k = length(unique(dat(:, 2)));
    
    m = reshape(dat, [k n/k 3]);
    
    rates = m(1, :, 1);
    
    m(:, :, 3);
    
    times = mean(m(:, :, 3));
    
    std(m(:, :, 3));
    
    plot(rates / 65536, times, styles{i});
    
end

xlabel('Injection Rate');

ylabel('Mean Packet Delivery Time (cycles)');

set(gca, 'xscale', 'log');

ylim([0 500]);

grid on; box on;

legend({'noc', 'meta-noc'});

end