; PLANTILLA DE ENFERMEDADES
(deftemplate enfermedad
   (slot nombre)
   (slot tipo)
   (multislot sintomas))

; HECHOS INICIALES
(deffacts hechos-iniciales
   (enfermedad (nombre gripe) (tipo viral) (sintomas fiebre tos "congestion nasal" fatiga))
   (enfermedad (nombre "COVID-19") (tipo viral) (sintomas fiebre tos "dificultad para respirar" "perdida del olfato"))
   (enfermedad (nombre "neumonia bacteriana") (tipo bacteriana) (sintomas fiebre tos "dolor en el pecho" "dificultad para respirar"))
   (enfermedad (nombre tuberculosis) (tipo bacteriana) (sintomas tos "fiebre nocturna" "sudores nocturnos" "perdida de peso"))
   (enfermedad (nombre "hepatitis B") (tipo viral) (sintomas ictericia fatiga "dolor abdominal" nauseas))
   (enfermedad (nombre salmonelosis) (tipo bacteriana) (sintomas diarrea "dolor abdominal" fiebre vomitos))
   (enfermedad (nombre varicela) (tipo viral) (sintomas "erupcion cutanea" fiebre fatiga picazon))
   (enfermedad (nombre gonorrea) (tipo bacteriana) (sintomas "dolor al orinar" secrecion inflamacion))
   (enfermedad (nombre dengue) (tipo viral) (sintomas fiebre "dolor muscular" "dolor articular" "erupcion cutanea"))
   (enfermedad (nombre "meningitis bacteriana") (tipo bacteriana) (sintomas fiebre "rigidez en el cuello" confusion nauseas)))

; REGLAS PARA CONSULTAS

; Regla: Buscar enfermedades por tipo
(defrule buscar-por-tipo-viral
   (enfermedad (nombre ?nombre) (tipo ?tipo&viral) (sintomas $?sintomas))
   =>
   (printout t "Enfermedad: " ?nombre ", Tipo: " ?tipo ", Síntomas: " ?sintomas crlf))

; Regla: Buscar enfermedades por síntoma
(defrule buscar-por-sintoma-fiebre
   ?fact <- (enfermedad (nombre ?nombre) (sintomas $? ?sintoma&fiebre $?))
   =>
   (printout t "La enfermedad " ?nombre " presenta el síntoma: " ?sintoma crlf))

; FUNCIONES PARA GESTIONAR ENFERMEDADES

; Agregar enfermedad
(deffunction agregar-enfermedad (?nombre ?tipo $?sintomas)
   (assert (enfermedad (nombre ?nombre) (tipo ?tipo) (sintomas $?sintomas)))
   (printout t "Enfermedad agregada: " ?nombre crlf))

; Actualizar enfermedad
(deffunction actualizar-enfermedad (?nombre ?nuevo-tipo $?nuevos-sintomas)
   (do-for-all-facts ((?e enfermedad)) 
      (and (or (eq ?e:tipo bacteriana) (eq ?e:tipo viral))
           (eq ?e:nombre ?nombre))
      (retract ?e))
   (assert (enfermedad (nombre ?nombre) (tipo ?nuevo-tipo) (sintomas $?nuevos-sintomas)))
   (printout t "Enfermedad actualizada: " ?nombre crlf))

; Borrar enfermedad
(deffunction borrar-enfermedad (?nombre)
   (do-for-all-facts ((?e enfermedad)) 
      (eq ?e:nombre ?nombre)
      (retract ?e))
   (printout t "Enfermedad borrada: " ?nombre crlf))