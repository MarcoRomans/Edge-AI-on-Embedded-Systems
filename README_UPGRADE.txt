README — Esperimento Qwen Real-Time su BeagleBone AI-64

L'esperimento ha avuto lo scopo di valutare il comportamento temporale dell'inferenza di **Qwen 2.5 0.5B** in condizioni di stress, riducendo le interferenze del sistema operativo tramite isolamento della CPU e misurando aspetti come latenza, deadline miss e jitter.

1. Configurazione dell'isolamento

È stata configurata la CPU1 come core isolato, lasciando la CPU0 alle attività di housekeeping e agli interrupt. Nel file di boot:

/boot/firmware/extlinux/extlinux.conf

sono stati aggiunti i parametri:

isolcpus=1 nohz_full=1 rcu_nocbs=1 irqaffinity=0

In sintesi:
- `isolcpus=1` esclude la CPU1 dal normale scheduling Linux;
- `nohz_full=1` riduce il tick periodico sulla CPU1;
- `rcu_nocbs=1` sposta le callback RCU fuori dalla CPU1;
- `irqaffinity=0` indirizza gli interrupt verso la CPU0.

Dopo il reboot, l'isolamento è stato verificato con:

cat /sys/devices/system/cpu/isolated

ottenendo `1`.

2. Preparazione dell'ambiente

La memoria USB contenente il progetto è stata rimontata e il progetto è stato raggiunto tramite:

cd /mnt/i1data/i1-edge-ai-slm

Sono stati verificati i modelli disponibili, scegliendo per la prova il modello:

models/qwen2.5-0.5b-instruct-q4_k_m.gguf

3. Configurazione dello stress

Per simulare un carico concorrente, è stato utilizzato `stress-ng` sulla CPU0:

cd /tmp
taskset -c 0 stress-ng --cpu 1 --cpu-method matrixprod --metrics-brief &

L'esecuzione sulla CPU0 è stata verificata tramite `ps`, controllando il valore `PSR`.

4. Preparazione della run real-time

È stato individuato lo script:

scripts/run_qwen05_realtime_loop_temp07.sh

Poiché la nuova configurazione prevedeva l'inferenza sulla CPU1 isolata e lo stress sulla CPU0, è stata creata una copia dedicata:

scripts/run_qwen05_realtime_loop_temp07_isolated_cpu1.sh

Sono quindi stati impostati:

INFERENCE_CORE="1"
STRESS_CORE="0"

Lo script è stato reso eseguibile con:

sudo chmod +x scripts/run_qwen05_realtime_loop_temp07_isolated_cpu1.sh

5. Esecuzione dell'esperimento

La run è stata avviata in modalità `isolation`:

sudo ./scripts/run_qwen05_realtime_loop_temp07_isolated_cpu1.sh isolation

La configurazione risultante è:

CPU0 → housekeeping + stress-ng
CPU1 → inferenza Qwen real-time

L'inferenza viene eseguita tramite `llama-completion` e vincolata alla CPU1 tramite `taskset`.

Durante l'esecuzione è stato verificato l'assegnamento dei processi:

ps -eo pid,psr,comm,args | grep -E "python|llama|stress" | grep -v grep

La verifica ha confermato `stress-ng` su CPU0 e `llama-completion` su CPU1.

6. Risultati prodotti

La run real-time ha previsto 30 iterazioni e ha prodotto:
- un CSV con i dati delle singole iterazioni;
- un CSV di riepilogo;
- i log delle singole run.

Lo scenario prodotto è identificato come:

realtime_stress_cpu_matrix_process_isolation

Le metriche di interesse includono latenza, deadline miss, deadline miss ratio e jitter.

7. Configurazione finale

L'esperimento può essere riassunto come:

Qwen 2.5 0.5B
Temperature: 0.7
Real-time loop: 30 iterazioni

CPU0:
  - Linux housekeeping
  - interrupt / callback RCU
  - stress-ng

CPU1:
  - CPU isolata a livello kernel
  - inferenza Qwen tramite llama-completion
  - process isolation tramite taskset

Questa configurazione è stata utilizzata per valutare la prevedibilità temporale dell'inferenza in presenza di stress controllato, con l'obiettivo di ridurre la variabilità della latenza e il jitter.
