# Edge AI on Embedded Systems - Qwen2.5 on BeagleBone AI-64

## Descrizione del progetto

Questo progetto è stato sviluppato nell'ambito dell'attività su Edge AI on Embedded Systems.  
L'obiettivo principale è stato valutare l'esecuzione di modelli linguistici di piccole dimensioni su una piattaforma embedded, cercando di capire quali prestazioni si riescono a ottenere e quali limiti emergono quando si usano modelli di tipo Small Language Model su hardware con risorse limitate.

La piattaforma utilizzata è stata la BeagleBone AI-64, sulla quale sono stati testati diversi modelli della famiglia Qwen2.5. Gli esperimenti si sono concentrati soprattutto sulla latenza, sul throughput, sull'accuratezza, sulla stabilità sotto stress CPU e sul comportamento in un semplice scenario real-time.

L'idea del lavoro non era soltanto verificare se i modelli riuscissero a generare una risposta, ma anche capire se questa risposta potesse arrivare in tempi compatibili con un possibile uso embedded. Per questo motivo sono stati fatti test in condizioni normali, sotto interferenza CPU e in un loop real-time con deadline prefissate.

## Board utilizzata

Gli esperimenti sono stati eseguiti sulla board:

BeagleBone AI-64

La board è stata collegata al PC tramite rete USB. L'accesso alla board è stato effettuato tramite SSH, usando l'indirizzo locale della BeagleBone.

Durante il lavoro è stato utilizzato il seguente percorso principale sulla board:

/mnt/i1data/i1-edge-ai-slm

La scelta di lavorare su una memoria esterna è stata necessaria perché la memoria interna della board non era sufficiente per contenere comodamente modelli, runtime, script e risultati sperimentali. I modelli GGUF, infatti, occupano centinaia di MB o diversi GB a seconda della dimensione.

La memoria esterna è stata montata nel percorso:

/mnt/i1data

e da lì è stata creata la cartella principale del progetto:

/mnt/i1data/i1-edge-ai-slm

All'interno sono state organizzate le cartelle per modelli, script, prompt, risultati e log.

## Configurazione della board

Prima di eseguire gli esperimenti è stato necessario preparare la board.

I passaggi principali sono stati:

- accesso alla BeagleBone AI-64 tramite SSH;
- verifica del corretto montaggio della memoria esterna;
- creazione della directory di progetto;
- preparazione delle cartelle per modelli, script, prompt, risultati e log;
- verifica dello spazio disponibile;
- compilazione e utilizzo di llama.cpp;
- verifica del numero di core disponibili;
- installazione e test di stress-ng per gli esperimenti di interferenza CPU.

La struttura di lavoro usata sulla board era indicativamente:

/mnt/i1data/i1-edge-ai-slm/
├── models/
├── scripts/
├── prompts/
├── results/
├── logs/
└── tools/

Il runtime utilizzato per l'inferenza dei modelli Qwen è stato llama.cpp, attraverso il comando llama-completion.

La scelta di llama.cpp è stata fatta perché consente di eseguire modelli in formato GGUF anche su dispositivi con risorse limitate, usando quantizzazione e inferenza locale su CPU.

## Configurazione dei modelli Qwen

Sono stati testati tre modelli della famiglia Qwen2.5:

- Qwen2.5-0.5B-Instruct Q4_K_M
- Qwen2.5-1.5B-Instruct Q4_K_M
- Qwen2.5-3B-Instruct Q4_K_M

I modelli sono stati usati in formato GGUF quantizzato.  
I file dei modelli erano salvati localmente nella cartella:

/mnt/i1data/i1-edge-ai-slm/models/

I percorsi utilizzati erano:

/mnt/i1data/i1-edge-ai-slm/models/qwen2.5-0.5b-instruct-q4_k_m.gguf

/mnt/i1data/i1-edge-ai-slm/models/qwen2.5-1.5b-instruct-q4_k_m.gguf

/mnt/i1data/i1-edge-ai-slm/models/qwen2.5-3b-instruct-q4_k_m.gguf

I modelli sono stati scelti per confrontare tre livelli diversi di complessità:

Qwen2.5-0.5B è il modello più leggero, quindi quello più adatto a testare scenari con vincoli temporali più stretti.

Qwen2.5-1.5B rappresenta una configurazione intermedia, utile per valutare un compromesso tra qualità dell'output e prestazioni.

Qwen2.5-3B è il modello più grande tra quelli considerati ed è stato usato per verificare il limite della piattaforma.

I modelli veri e propri non sono inclusi nel repository perché hanno dimensioni elevate.

## Passaggi svolti per far funzionare l'inferenza

Per arrivare all'esecuzione dei modelli sulla BeagleBone AI-64 sono stati svolti diversi passaggi.

Inizialmente è stata configurata la memoria esterna, perché la memoria interna della board non era sufficiente. Dopo il montaggio della memoria, è stata creata la cartella principale del progetto.

Successivamente sono stati copiati sulla board i modelli Qwen in formato GGUF. I modelli sono stati scaricati sul PC e poi trasferiti sulla board, perché la BeagleBone non riusciva ad accedere correttamente a Internet a causa di problemi di risoluzione DNS.

Dopo aver copiato i modelli, è stato configurato llama.cpp. Il runtime è stato utilizzato per eseguire inferenze locali sui modelli Qwen. Prima di eseguire i benchmark completi, sono stati fatti test semplici per verificare che i modelli venissero caricati correttamente e che producessero output.

Una volta verificato il funzionamento di base, è stato preparato un set di prompt per il benchmark. Il set includeva prompt di tipo aritmetico, classificazione, scelta multipla, JSON, real-time e risposte discorsive.

Per gli esperimenti baseline sono state usate tre temperature:

- 0.5
- 0.7
- 1.0

Per ogni configurazione sono state raccolte metriche come latenza, throughput, accuracy, exact match e BERTScore.

Per gli esperimenti con stress CPU è stato usato stress-ng, mentre per l'isolamento dei processi è stato usato taskset, in modo da separare il processo di inferenza e il processo di stress su core diversi.

## Struttura del repository

Il repository è organizzato nel seguente modo:

Edge-AI-on-Embedded-Systems/
├── models/
├── plot/
├── raw_data/
├── script/
├── README.md
├── .gitignore
└── .gitattributes

La cartella models contiene informazioni sui modelli utilizzati. I file GGUF non sono stati caricati nel repository per motivi di dimensione.

La cartella raw_data contiene i CSV ottenuti dagli esperimenti.

La cartella script contiene gli script e i comandi usati per documentare il workflow sperimentale.

La cartella plot contiene i grafici generati a partire dai risultati.

La struttura dei dati grezzi è organizzata per modello e per punto sperimentale:

raw_data/
├── qwen05/
│   ├── point2_baseline/
│   ├── point3_stress_isolation/
│   └── point4_realtime_loop/
├── qwen15/
│   ├── point2_baseline/
│   ├── point3_stress_isolation/
│   └── point4_realtime_loop/
└── qwen3b/
    ├── point2_baseline/
    ├── point3_stress_isolation/
    └── point4_realtime_loop/

La cartella degli script è organizzata così:

script/
├── point2_baseline/
├── point3_stress_isolation/
├── point4_realtime_loop/
└── utilities/

La cartella dei grafici è organizzata così:

plot/
├── point2_baseline/
├── point3_stress_isolation/
└── point4_realtime_loop/

## Punto 2 - Baseline

Nel punto 2 è stata eseguita una valutazione baseline dei modelli.

Lo scopo era misurare il comportamento dei modelli in condizioni normali, quindi senza carichi interferenti sulla CPU.

Sono stati testati i tre modelli Qwen2.5 con temperature 0.5, 0.7 e 1.0.

Le metriche considerate sono state:

- latenza media;
- deviazione standard della latenza;
- latenza minima;
- latenza massima;
- time-to-first-token;
- throughput;
- accuracy;
- exact match;
- BERTScore per le risposte discorsive.

Dai risultati ottenuti, Qwen2.5-0.5B è risultato il modello più veloce.  
Qwen2.5-1.5B ha mostrato il miglior compromesso tra qualità dell'output e prestazioni.  
Qwen2.5-3B è risultato eseguibile nella baseline, ma con tempi molto più elevati rispetto agli altri due modelli.

In particolare, il 3B ha mostrato latenze molto alte e throughput basso, quindi è risultato poco adatto a scenari con vincoli temporali.

## Punto 3 - Stress CPU e isolamento

Nel punto 3 è stato introdotto un carico interferente sulla CPU per valutare la robustezza dell'inferenza.

Lo stress è stato generato tramite il comando:

stress-ng --cpu 2 --cpu-method matrixprod --metrics-brief

Sono stati confrontati tre scenari:

- baseline;
- stress CPU;
- stress CPU con isolamento dei processi.

L'isolamento è stato realizzato tramite taskset.  
L'idea era assegnare il processo di inferenza a un core e il processo di stress a un altro core.

In questo modo è stato possibile verificare se la separazione dei processi potesse ridurre l'interferenza.

Dai risultati è emerso che lo stress CPU peggiora in modo evidente le prestazioni. In particolare, aumenta la latenza, aumenta la variabilità dei tempi e riduce il throughput.

L'isolamento tramite CPU affinity ha migliorato alcuni aspetti, soprattutto la stabilità e il jitter, ma non sempre è riuscito a riportare le prestazioni ai valori della baseline.

Questo è abbastanza comprensibile, perché la board ha risorse limitate e, anche separando i processi, il sistema rimane comunque vincolato dalla capacità complessiva della CPU e dalla memoria disponibile.

## Punto 4 - Real-time loop

Nel punto 4 è stato implementato un semplice real-time loop.

In questo esperimento il modello viene eseguito più volte sullo stesso prompt di classificazione.  
L'obiettivo non è solo ottenere una risposta corretta, ma ottenere la risposta entro una deadline.

Le metriche considerate sono state:

- latenza;
- throughput;
- jitter;
- accuracy;
- deadline miss ratio.

Il deadline miss ratio indica quante inferenze superano il tempo massimo consentito.

In un contesto real-time, infatti, non basta che il risultato sia giusto. Il risultato deve arrivare anche in tempo. Per questo motivo una risposta corretta ma arrivata troppo tardi viene comunque considerata problematica dal punto di vista real-time.

Gli esperimenti quantitativi del punto 4 sono stati svolti sui modelli:

- Qwen2.5-0.5B
- Qwen2.5-1.5B

Il modello Qwen2.5-3B è stato invece testato, ma è stato riportato soltanto come caso di non fattibilità.

## Tentativi per Qwen2.5-3B nel real-time loop

Qwen2.5-3B è stato inizialmente considerato anche per il punto 4, perché era stato possibile eseguirlo nella baseline.

Tuttavia, quando è stato inserito nel real-time loop, il modello non ha prodotto inferenze valide sulla BeagleBone AI-64.

Sono stati fatti diversi tentativi per ridurre il carico del modello, abbassando i parametri di esecuzione.

In particolare, sono stati ridotti:

- numero di run;
- numero di token generati;
- contesto del modello.

Una configurazione di test usata per provare a farlo partire è stata:

N_RUNS = 3
N_TOKENS = 4
CTX = 256

Questa configurazione era molto ridotta rispetto agli altri esperimenti e serviva solo per verificare se il modello riuscisse almeno a completare qualche inferenza valida.

Nonostante questa riduzione, il runtime ha restituito un errore di memoria:

failed to fit params to free device memory: was unable to fit model into system memory by reducing context, abort

Questo errore indica che il modello non riusciva a essere eseguito correttamente nel loop real-time con le risorse disponibili sulla board.

Il CSV generato durante questo tentativo non è stato quindi considerato un risultato sperimentale valido, perché non contiene vere inferenze completate dal modello, ma documenta il fallimento dell'esecuzione.

Per questo motivo Qwen2.5-3B è stato escluso dal confronto quantitativo del punto 4.

Nel progetto viene riportato come caso di limite hardware: il modello è eseguibile in baseline, ma non è adatto a un'esecuzione ripetuta in real-time loop sulla BeagleBone AI-64.

## Tentativi sulla pipeline NPU/TIDL

Oltre alla pipeline CPU con llama.cpp, è stata analizzata anche la possibilità di usare l'accelerazione hardware della BeagleBone AI-64.

La board dispone dello stack TIDL di Texas Instruments e supporta provider come:

- TIDLExecutionProvider;
- TIDLCompilationProvider;
- CPUExecutionProvider.

Per questo motivo è stato verificato se fosse possibile eseguire Qwen tramite una pipeline ONNX/TIDL.

Tuttavia, i risultati principali del progetto sono stati ottenuti con modelli Qwen in formato GGUF tramite llama.cpp. Questa pipeline non utilizza direttamente TIDL e non fa offload automatico sulla NPU.

Per usare TIDL sarebbe invece necessario avere un modello compatibile con ONNX Runtime/TIDL e con gli operatori supportati dallo stack disponibile sulla board.

Sono stati quindi provati alcuni modelli Qwen in formato ONNX.

Un primo tentativo è stato fatto con un modello Qwen2.5-0.5B in formato ONNX. La board riconosceva correttamente i provider disponibili, ma il modello non veniva caricato correttamente.

L'errore ottenuto era:

Unknown model file format version

Dopo aver ispezionato il modello, è emerso che usava una versione del formato ONNX e un opset non compatibili con il runtime disponibile sulla board.

È stato poi provato un tentativo di conversione verso una versione più vecchia dell'opset, ma la conversione standard non è andata a buon fine.

Successivamente è stato tentato un downgrade forzato dei metadati del modello ONNX, portandolo a una versione teoricamente più compatibile. In questo caso il primo errore veniva superato, ma il runtime falliva su un operatore non registrato:

MatMulNBits is not a registered function/op

Questo errore indica che il modello usava operatori quantizzati moderni non supportati dalla versione di ONNX Runtime/TIDL disponibile sulla BeagleBone.

È stato considerato anche un altro modello Qwen ONNX più recente, ma l'ispezione ha mostrato la presenza di opset moderni e operatori specifici, ancora meno compatibili con il runtime della board.

È stato infine valutato anche l'export locale tramite Optimum, ma l'esportazione verso opset compatibili ha presentato problemi legati ad operatori di attention non supportati nelle versioni più vecchie.

In sintesi, i tentativi su NPU/TIDL non hanno portato a una inferenza valida di Qwen.

I problemi principali sono stati:

- formato ONNX troppo recente;
- opset non compatibile con il runtime della board;
- operatori quantizzati non supportati;
- operatori di attention non compatibili;
- differenza tra modelli linguistici generativi e modelli tipicamente supportati da TIDL.

Per questo motivo Qwen è stato mantenuto nella pipeline CPU tramite GGUF e llama.cpp.

La NPU/TIDL viene quindi considerata come possibile sviluppo futuro, ma probabilmente con modelli NLP più semplici e compatibili, ad esempio modelli encoder-only per classificazione testuale, come TinyBERT, DistilBERT, MobileBERT o MiniLM.

## Considerazioni sui risultati

Dai risultati ottenuti emerge che la BeagleBone AI-64 riesce a eseguire modelli Qwen2.5 quantizzati, ma con limiti importanti.

Il modello Qwen2.5-0.5B è quello più leggero e veloce. È il più adatto quando la priorità è ridurre la latenza.

Il modello Qwen2.5-1.5B è risultato il più equilibrato, perché mantiene una qualità migliore rispetto allo 0.5B senza diventare pesante quanto il 3B.

Il modello Qwen2.5-3B è stato utile per mostrare il limite della piattaforma. Anche se riesce a funzionare in baseline, diventa poco pratico quando si passa a scenari più vincolati, come il real-time loop.

Gli esperimenti con stress CPU hanno mostrato che il carico interferente degrada molto le prestazioni. L'isolamento tramite taskset può migliorare la stabilità, ma non risolve completamente il problema.

Questo conferma che, in ambiente embedded, non basta considerare solo la correttezza dell'output. Bisogna considerare anche il tempo di risposta, la variabilità, il carico del sistema e la capacità di rispettare deadline.

## Conclusioni

Il progetto ha mostrato che è possibile eseguire Small Language Models su una piattaforma embedded come la BeagleBone AI-64, ma con compromessi importanti.

La pipeline più stabile per i modelli Qwen testati è stata quella basata su GGUF e llama.cpp.

Qwen2.5-0.5B è risultato il modello più veloce.  
Qwen2.5-1.5B è risultato il miglior compromesso complessivo.  
Qwen2.5-3B è risultato troppo pesante per il real-time loop sulla board.

Gli esperimenti con stress CPU e isolamento hanno evidenziato che l'interferenza può peggiorare notevolmente le prestazioni e che l'isolamento aiuta soprattutto a ridurre la variabilità, ma non garantisce sempre il rispetto delle deadline.

I tentativi con NPU/TIDL hanno mostrato che l'esecuzione diretta di Qwen sulla NPU non è risultata praticabile con lo stack software disponibile. I principali problemi sono stati legati alla compatibilità ONNX, agli opset e agli operatori non supportati.

Come possibile sviluppo futuro, si potrebbe provare una pipeline NPU/TIDL con modelli NLP più semplici e compatibili, oppure valutare runtime più recenti pensati specificamente per modelli linguistici su dispositivi embedded.