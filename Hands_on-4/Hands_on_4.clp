;Templates -------------

(deftemplate smartphone
   (slot marca)
   (slot modelo)
   (slot color)
   (slot precio))

(deftemplate compu
   (slot marca)
   (slot modelo)
   (slot color)
   (slot precio))

(deftemplate accesorio
   (slot tipo)
   (slot precio))

(deftemplate cliente
   (slot nombre)
   (slot tipo)
   (slot tarjeta)
   (slot descuento))

(deftemplate orden
   (slot smartphone)
   (slot compu)
   (slot cantidad)
   (slot cliente)
   (slot accesorios)
   (slot se-compro-con))

(deftemplate tarjetacred
   (slot banco)
   (slot grupo)
   (slot exp-date))

(deftemplate vale
   (slot valor))

(deftemplate stock
   (slot marca)
   (slot modelo)
   (slot cantidad))

(deftemplate se-compro-con
    (slot banco))

;fin templates ------------

; Hechos de Smartphones
(assert (smartphone (marca apple) (modelo iPhone14) (color negro) (precio 25000)))
(assert (smartphone (marca samsung) (modelo GalaxyS21) (color azul) (precio 22000)))
(assert (smartphone (marca motorola) (modelo Edge 20) (color verde) (precio 18000)))
(assert (smartphone (marca xiaomi) (modelo Mi 11) (color blanco) (precio 19000)))
(assert (smartphone (marca google) (modelo Pixel 6) (color gris) (precio 23000)))

; Hechos de Computadores
(assert (compu (marca dell) (modelo XPS 13) (color plata) (precio 35000)))
(assert (compu (marca apple) (modelo macbook air) (color gris) (precio 47000)))
(assert (compu (marca lenovo) (modelo thinkpad x1) (color negro) (precio 42000)))
(assert (compu (marca hp) (modelo pavilion x360) (color azul) (precio 33000)))
(assert (compu (marca asus) (modelo zenbook) (color verde) (precio 38000)))

; Hechos de Tarjetas de Crédito
(assert (tarjetacred (banco bbva) (grupo visa) (exp-date "01-12-23") (cliente juan) (tipo "oro")))
(assert (tarjetacred (banco banamex) (grupo mastercard) (exp-date "01-06-24") (cliente maria) (tipo "platino")))
(assert (tarjetacred (banco santander) (grupo visa) (exp-date "01-11-25") (cliente pedro) (tipo "básica")))
(assert (tarjetacred (banco citibanamex) (grupo visa) (exp-date "01-12-23") (cliente laura) (tipo "oro")))
(assert (tarjetacred (banco hsbc) (grupo mastercard) (exp-date "01-03-24") (cliente ana) (tipo "básica")))

; Hechos de Clientes
(assert (cliente (nombre juan) (edad 25) (tipo cliente "mayorista") (compras 3)))
(assert (cliente (nombre maria) (edad 30) (tipo cliente "menudista") (compras 5)))
(assert (cliente (nombre pedro) (edad 40) (tipo cliente "mayorista") (compras 8)))
(assert (cliente (nombre laura) (edad 22) (tipo cliente "menudista") (compras 1)))
(assert (cliente (nombre ana) (edad 50) (tipo cliente "mayorista") (compras 2)))

; Hechos de Accesorios
(assert (accesorio (tipo funda) (marca apple) (color negro) (precio 500)))
(assert (accesorio (tipo mica) (marca samsung) (color transparente) (precio 200)))
(assert (accesorio (tipo cargador) (marca motorola) (color blanco) (precio 300)))
(assert (accesorio (tipo audífonos) (marca bose) (color negro) (precio 1200)))
(assert (accesorio (tipo funda) (marca xiaomi) (color rojo) (precio 150)))


; Hechos de Orden de Compra
(assert (orden (smartphone (marca apple) (modelo iPhone14) (cantidad 10)) (cliente juan) (fecha "2024-11-15") (total 250000)))
(assert (orden (compu (marca dell) (modelo XPS 13) (cantidad 2)) (cliente maria) (fecha "2024-11-16") (total 70000)))
(assert (orden (smartphone (marca samsung) (modelo GalaxyS21) (cantidad 15)) (cliente pedro) (fecha "2024-11-17") (total 330000)))
(assert (orden (compu (marca lenovo) (modelo thinkpad x1) (cantidad 5)) (cliente laura) (fecha "2024-11-18") (total 210000)))
(assert (orden (smartphone (marca motorola) (modelo Edge 20) (cantidad 20)) (cliente ana) (fecha "2024-11-19") (total 380000)))

(assert (vale (cliente juan) (monto 1000) (fecha "2024-11-15") (tipo "compra en accesorios")))
(assert (vale (cliente maria) (monto 500) (fecha "2024-11-16") (tipo "compra en smartphones")))
(assert (vale (cliente pedro) (monto 2000) (fecha "2024-11-17") (tipo "compra en computadoras")))
(assert (vale (cliente laura) (monto 1500) (fecha "2024-11-18") (tipo "compra en accesorios")))
(assert (vale (cliente ana) (monto 3000) (fecha "2024-11-19") (tipo "compra en smartphones")))

(assert (descuento (producto smartphone) (tipo "funda") (porcentaje 15) (aplicado "no")))
(assert (descuento (producto computadora) (tipo "audífonos") (porcentaje 10) (aplicado "no")))

(assert (stock (producto smartphone) (modelo iPhone16) (cantidad 50)))
(assert (stock (producto compu) (modelo macbook air) (cantidad 20)))
(assert (stock (producto accesorio) (tipo funda) (cantidad 200)))

;Reglas
(defrule iphone-16-banamex
   (orden (smartphone (marca ?marca) (modelo ?modelo)))
   (orden (se-compro-con (banco banamex)))
   =>
   (printout t "Oferta: 24 meses sin intereses para compra de iPhone 16 con tarjeta Banamex" crlf))


(defrule samsung-banregio
   (orden (smartphone (marca samsung) (modelo "Note 21")))
   (orden (se-compro-con (banco banregio)))
   =>
   (printout t "Oferta: 12 meses sin intereses para compra de Samsung Note 21 con tarjeta Liverpool VISA" crlf))

(defrule descuento-accesorios
   (orden (smartphone (marca apple) (modelo iPhone16)) (compu ?compu) (cantidad ?cantidad))
   =>
   (bind ?descuento (* 0.15 (sumar-precio-accesorios)))
   (printout t "Descuento en accesorios: " ?descuento crlf))

(defrule vales-al-contado
   (orden (smartphone (marca apple) (modelo iPhone16)) (compu (marca apple) (modelo "MacBookAir")))
   (test (>= (sumar-precio) 1000))
   =>
   (bind ?vales (* 0.1 (sumar-precio)))
   (printout t "Ofrecemos " ?vales " en vales por compra al contado" crlf))

(defrule iphone-16-bbva
   (orden (smartphone (marca apple) (modelo iPhone16)))
   (orden (se-compro-con (banco bbva)))
   =>
   (printout t "Oferta: 12 meses sin intereses para compra de iPhone 16 con tarjeta BBVA" crlf))

(defrule descuento-smartphone-computadora
   (orden (smartphone ?smartphone) (compu ?compu) (cantidad ?cantidad))
   (test (> ?cantidad 0))
   =>
   (bind ?descuento (* 0.10 (sumar-precio-accesorios)))
   (printout t "Descuento en accesorios: " ?descuento crlf))

(defrule descuento-mayor-50000
   (orden (smartphone ?smartphone) (compu ?compu) (cantidad ?cantidad))
   (test (> (sumar-precio) 50000))
   =>
   (bind ?descuento (* 0.05 (sumar-precio)))
   (printout t "Descuento adicional del 5%: " ?descuento crlf))

(defrule samsung-12-meses
   (orden (smartphone (marca samsung)))
   (orden (se-compro-con (grupo visa)))
   =>
   (printout t "Oferta: 12 meses sin intereses para compra de productos Samsung con tarjeta VISA" crlf))

(defrule descuento-fundas-micas
   (orden (smartphone ?smartphone))
   =>
   (bind ?descuento (* 0.20 (sumar-precio-accesorios)))
   (printout t "Descuento del 20% en fundas y micas" crlf))

(defrule descuento-computadora-apple-mayorista
   (orden (compu (marca apple)))
   (orden (cliente ?cliente) (tipo mayorista))
   =>
   (bind ?descuento (* 0.10 (sumar-precio)))
   (printout t "Descuento mayorista en computadoras Apple: " ?descuento crlf))

(defrule hp-6-meses-bbva
   (orden (compu (marca hp)))
   (orden (se-compro-con (banco bbva)))
   =>
   (printout t "Oferta: 6 meses sin intereses para compras de productos HP con tarjeta BBVA" crlf))

(defrule descuento-iphone16-banorte
   (orden (smartphone (marca apple) (modelo iPhone16)))
   (orden (se-compro-con (banco banorte)))
   =>
   (bind ?descuento (* 0.15 (sumar-precio)))
   (printout t "Descuento del 15% en compra de iPhone 16 con tarjeta Banorte: " ?descuento crlf))

(defrule descuento-accesorios-menudista
   (orden (accesorio ?accesorio))
   (orden (cliente ?cliente) (tipo menudista))
   =>
   (bind ?descuento (* 0.10 (fact-slot-value ?accesorio precio)))
   (printout t "Descuento del 10% en accesorios para clientes menudistas" crlf))

(defrule descuento-accesorios-40000
   (orden (smartphone ?smartphone) (compu ?compu) (cantidad ?cantidad))
   (test (> (sumar-precio) 40000))
   =>
   (bind ?descuento (* 0.30 (sumar-precio-accesorios)))
   (printout t "Descuento del 30% en accesorios por compras mayores a 40,000 pesos" crlf))

(defrule descuento-lenovo-santander
   (orden (compu (marca lenovo)))
   (orden (se-compro-con (banco santander)))
   =>
   (bind ?descuento (* 0.10 (sumar-precio)))
   (printout t "Descuento del 10% en computadoras Lenovo con tarjeta Santander" crlf))

(defrule descuento-iphone15-macbook
   (orden (smartphone (marca apple) (modelo iPhone15)))
   (orden (compu (marca apple) (modelo "MacBookAir")))
   =>
   (bind ?descuento (* 0.20 (sumar-precio)))
   (printout t "Descuento del 20% por comprar un iPhone 15 y un MacBook Air" crlf))

(defrule descuento-computadoras-no-apple
   (orden (compu (marca ?marca)))
   (test (neq ?marca apple))
   =>
   (bind ?descuento (* 0.10 (sumar-precio)))
   (printout t "Descuento del 10% en computadoras de marcas no Apple" crlf))

(defrule descuento-smartphones-100000
   (orden (smartphone ?smartphone))
   (test (> (sumar-precio) 100000))
   =>
   (bind ?descuento (* 0.05 (sumar-precio)))
   (printout t "Descuento del 5% en smartphones de más de 100,000 pesos" crlf))

(defrule recargo-menudista-30000
   (orden (smartphone ?smartphone) (compu ?compu))
   (orden (cliente ?cliente) (tipo menudista))
   (test (> (sumar-precio) 30000))
   =>
   (bind ?recargo (* 0.05 (sumar-precio)))
   (printout t "Recargo del 5% por compras superiores a 30,000 pesos para clientes menudistas: " ?recargo crlf))

(defrule descuento-contado-computadora
   (orden (compu ?compu))
   (test (= (fact-slot-value ?compu precio) 0))
   =>
   (bind ?descuento (* 0.10 (sumar-precio)))
   (printout t "Descuento del 10% en computadoras por pago al contado" crlf))







(defrule determinar-cliente
   (orden (smartphone (marca ?marca) (modelo ?modelo)) (cliente (tipo ?tipo)) (cantidad ?cantidad))
   (test (< ?cantidad 10))
   =>
   (printout t "El cliente es menudista porque compró menos de 10 unidades." crlf))

(defrule determinar-cliente-mayorista
   (orden (smartphone (marca ?marca) (modelo ?modelo)) (cliente (tipo ?tipo)) (cantidad ?cantidad))
   (test (> ?cantidad 10))
   =>
   (printout t "El cliente es mayorista porque compró más de 10 unidades." crlf))





(defrule actualizar-stock
   (orden (smartphone (marca ?marca) (modelo ?modelo)) (qty ?qty))
   (stock (marca ?marca) (modelo ?modelo) (cantidad ?stock))
   (test (> ?stock 0))
   =>
   (bind ?nuevo-stock (- ?stock ?qty))
   (retract (stock (marca ?marca) (modelo ?modelo) (cantidad ?stock)))
   (assert (stock (marca ?marca) (modelo ?modelo) (cantidad ?nuevo-stock)))
   (printout t "Stock actualizado para " ?marca " " ?modelo ": " ?nuevo-stock " unidades restantes." crlf))


; funciones

(deffunction sumar-precio-accesorios ()
   (bind ?total 0)
   (do-for-all-facts ((?f accesorio)) 
      (bind ?total (+ ?total (fact-slot-value ?f precio))))
   ?total)

(deffunction sumar-precio ()
   (bind ?total 0)
   (do-for-all-facts ((?f smartphone)) 
      (bind ?total (+ ?total (fact-slot-value ?f precio))))
   (do-for-all-facts ((?f compu)) 
      (bind ?total (+ ?total (fact-slot-value ?f precio))))
   ?total)
