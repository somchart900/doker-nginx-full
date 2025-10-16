<?php
$start = microtime(true);
for ($i = 0; $i < 10000; $i++) {
    hash('sha256', 'test'.$i);
}
$end = microtime(true);
echo "Execution time: " . round($end - $start, 4) . " seconds";
