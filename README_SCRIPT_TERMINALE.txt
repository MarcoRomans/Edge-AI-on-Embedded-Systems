## Istruzioni da terminale per avviare gli esperimenti

Per eseguire gli esperimenti sulla BeagleBone AI-64, il primo passaggio è collegarsi alla board tramite SSH dal PC. La board è stata raggiunta tramite rete USB usando l'indirizzo locale 192.168.7.2.

Il comando usato per collegarsi è:

ssh debian@192.168.7.2

Dopo l'accesso alla board, bisogna entrare nella cartella principale del progetto, che si trova sulla memoria esterna:

cd /mnt/i1data/i1-edge-ai-slm

Prima di avviare gli esperimenti è utile verificare che la memoria esterna sia montata correttamente:

df -h /mnt/i1data

I modelli devono essere presenti nella cartella:

/mnt/i1data/i1-edge-ai-slm/models/

Gli script devono essere presenti nella cartella:

/mnt/i1data/i1-edge-ai-slm/scripts/

Il runtime usato per l'inferenza è llama.cpp, tramite il comando llama-completion. I modelli Qwen2.5 sono stati eseguiti in formato GGUF quantizzato.

Per eseguire un esperimento baseline si utilizza lo script principale run_qwen_benchmark_final.py, specificando il nome del modello, il percorso del file GGUF e la temperatura.

Esempio di baseline per Qwen2.5-0.5B con temperatura 0.7:

python3 scripts/run_qwen_benchmark_final.py --model-label qwen05 --model-path /mnt/i1data/i1-edge-ai-slm/models/qwen2.5-0.5b-instruct-q4_k_m.gguf --temperature 0.7

Esempio di baseline per Qwen2.5-1.5B con temperatura 0.7:

python3 scripts/run_qwen_benchmark_final.py --model-label qwen15 --model-path /mnt/i1data/i1-edge-ai-slm/models/qwen2.5-1.5b-instruct-q4_k_m.gguf --temperature 0.7

Esempio di baseline per Qwen2.5-3B con temperatura 0.7:

python3 scripts/run_qwen_benchmark_final.py --model-label qwen25_3b --model-path /mnt/i1data/i1-edge-ai-slm/models/qwen2.5-3b-instruct-q4_k_m.gguf --temperature 0.7

Negli esperimenti baseline sono state usate tre temperature: 0.5, 0.7 e 1.0. In questo modo è stato possibile confrontare il comportamento dei modelli al variare della temperatura di generazione.

Per valutare l'effetto di un carico interferente sulla CPU è stato utilizzato stress-ng. Il carico di stress è stato generato con il seguente comando:

stress-ng --cpu 2 --cpu-method matrixprod --metrics-brief

Durante lo stress CPU è stato poi eseguito lo stesso benchmark della baseline. Ad esempio, per Qwen2.5-0.5B sotto stress CPU:

python3 scripts/run_qwen_benchmark_final.py --model-label qwen05_stress_cpu_matrix --model-path /mnt/i1data/i1-edge-ai-slm/models/qwen2.5-0.5b-instruct-q4_k_m.gguf --temperature 0.7

In alternativa, per rendere più semplice l'esecuzione degli esperimenti con stress CPU, sono stati usati anche script dedicati:

bash scripts/run_qwen05_stress_cpu_matrix_temp07.sh

bash scripts/run_qwen15_stress_cpu_matrix_temp07.sh

bash scripts/run_qwen25_3b_stress_cpu_matrix_temp07.sh

Per gli esperimenti con isolamento dei processi è stato usato taskset, in modo da assegnare l'inferenza e lo stress CPU a core diversi. L'idea era usare un core per il modello e un core per il carico interferente.

In particolare:

core 0 -> inferenza del modello

core 1 -> stress CPU

Lo stress CPU vincolato al core 1 può essere avviato con:

taskset -c 1 stress-ng --cpu 1 --cpu-method matrixprod --metrics-brief

L'inferenza vincolata al core 0 può essere avviata, ad esempio per Qwen2.5-0.5B, con:

taskset -c 0 python3 scripts/run_qwen_benchmark_final.py --model-label qwen05_stress_cpu_matrix_process_isolation --model-path /mnt/i1data/i1-edge-ai-slm/models/qwen2.5-0.5b-instruct-q4_k_m.gguf --temperature 0.7

Anche per l'isolamento sono stati usati script dedicati, in modo da avviare direttamente gli esperimenti:

bash scripts/run_qwen05_process_isolation_temp07.sh

bash scripts/run_qwen15_process_isolation_temp07.sh

bash scripts/run_qwen25_3b_process_isolation_temp07.sh

Per il punto 4, cioè il real-time loop, sono stati usati script dedicati. In questo caso il modello viene eseguito più volte su un prompt fisso di classificazione e vengono misurate metriche come latenza, throughput, jitter, accuracy e deadline miss ratio.

Per avviare il real-time loop con Qwen2.5-0.5B:

bash scripts/run_qwen05_realtime_loop_temp07.sh

Per avviare il real-time loop con Qwen2.5-1.5B:

bash scripts/run_qwen15_realtime_loop_temp07.sh

È stato provato anche il real-time loop con Qwen2.5-3B:

bash scripts/run_qwen25_3b_realtime_loop_temp07.sh

Tuttavia, Qwen2.5-3B non ha prodotto risultati validi nel real-time loop. Anche riducendo il numero di run, il numero di token generati e la dimensione del contesto, il runtime ha restituito un errore di allocazione della memoria. Per questo motivo, il 3B è stato riportato solo come caso di non fattibilità nel punto 4.

I risultati degli esperimenti vengono salvati nella cartella:

/mnt/i1data/i1-edge-ai-slm/results/

Successivamente i CSV ottenuti sono stati organizzati nel repository GitHub nella cartella raw_data/, dividendoli per modello e per punto sperimentale.