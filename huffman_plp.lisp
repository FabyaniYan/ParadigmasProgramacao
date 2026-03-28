; EP1 - Huffman
; Nome: Fabyani Tiva Yan - RA: 10431835
; Nome: Rafael 

; estrutura basica do no da arvore
(defstruct no
  simb
  freq
  esq
  dir)

; verifica se é letra ou numero
(defun letra-ou-digito-p (c)
  (or (alpha-char-p c)
      (digit-char-p c)))

; remove coisas que nao interessam (pontuacao etc)
(defun limpar-txt (txt)
  (coerce
   (loop for c across (string-downcase txt)
         when (letra-ou-digito-p c)
         collect c)
   'string))

; le o arquivo inteiro
(defun ler-arq (nome)
  (with-open-file (arq nome :direction :input)
    (let ((txt (make-string (file-length arq))))
      (read-sequence txt arq)
      txt)))

; escreve no arquivo de saida
(defun escrever-arq (nome conteudo)
  (with-open-file (arq nome
                       :direction :output
                       :if-exists :supersede
                       :if-does-not-exist :create)
    (write-string conteudo arq)))

; conta quantas vezes cada caractere aparece
(defun contar-freq (txt)
  (let ((tbl (make-hash-table :test #'equal)))
    (loop for c across txt do
      (incf (gethash c tbl 0)))
    tbl))

; transforma a tabela em lista de nos
(defun tbl->lst-nos (tbl)
  (let (lst)
    (maphash
     (lambda (s f)
       (push (make-no :simb s
                      :freq f
                      :esq nil
                      :dir nil)
             lst))
     tbl)
    lst))

; ordena pelos menores primeiro
(defun ordenar-nos (lst)
  (sort lst #'< :key #'no-freq))

; monta a arvore de huffman juntando os menores
(defun montar-arv (lst)
  (let ((lst (ordenar-nos lst)))
    (cond
      ((null lst) nil)
      ((null (cdr lst)) (car lst))
      (t
       (loop while (> (length lst) 1) do
         (setf lst (ordenar-nos lst))
         (let* ((n1 (first lst))
                (n2 (second lst))
                ; cria novo no com soma das frequencias
                (novo (make-no :simb nil
                               :freq (+ (no-freq n1) (no-freq n2))
                               :esq n1
                               :dir n2)))
           (setf lst (cons novo (cddr lst)))))
       (car lst)))))

; percorre a arvore gerando os codigos
(defun gerar-cods-aux (arv cam tbl)
  (if (and (null (no-esq arv)) (null (no-dir arv)))
      ; chegou em folha
      (setf (gethash (no-simb arv) tbl)
            (if (string= cam "") "0" cam))
      (progn
        ; esquerda = 0
        (when (no-esq arv)
          (gerar-cods-aux (no-esq arv)
                          (concatenate 'string cam "0")
                          tbl))
        ; direita = 1
        (when (no-dir arv)
          (gerar-cods-aux (no-dir arv)
                          (concatenate 'string cam "1")
                          tbl)))))

; inicia a geracao dos codigos
(defun gerar-cods (arv)
  (let ((tbl (make-hash-table :test #'equal)))
    (when arv
      (gerar-cods-aux arv "" tbl))
    tbl))

; troca cada caractere pelo codigo
(defun codificar-txt (txt tbl-cods)
  (with-output-to-string (out)
    (loop for c across txt do
      (write-string (gethash c tbl-cods) out))))

; imprime frequencias (debug)
(defun mostrar-freq (tbl)
  (format t "~%Freq:~%")
  (maphash
   (lambda (k v)
     (format t "~a -> ~a~%" k v))
   tbl))

; imprime codigos (debug)
(defun mostrar-cods (tbl)
  (format t "~%Cods:~%")
  (maphash
   (lambda (k v)
     (format t "~a -> ~a~%" k v))
   tbl))

; funcao principal do huffman
(defun huffman-arq (in out)
  (let* ((txt-orig (ler-arq in))      ; le arquivo
         (txt (limpar-txt txt-orig))  ; limpa
         (freq (contar-freq txt))     ; conta freq
         (lst (tbl->lst-nos freq))    ; cria nos
         (arv (montar-arv lst))       ; arvore
         (cods (gerar-cods arv))      ; codigos
         (txt-cod (codificar-txt txt cods))) ; codifica
    
    (mostrar-freq freq)
    (mostrar-cods cods)
    
    (escrever-arq out txt-cod)
    
    (format t "~%Gerado: ~a~%" out)
    (format t "Tam orig: ~a~%" (length txt))
    (format t "Tam cod: ~a~%" (length txt-cod))))

; entrada do programa
(defun main ()
  (format t "Entrada: ")
  (finish-output)
  (let ((in (read-line)))
    (format t "Saida: ")
    (finish-output)
    (let ((out (read-line)))
      (huffman-arq in out))))


(main)