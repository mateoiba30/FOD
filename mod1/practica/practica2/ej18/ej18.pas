program ejer5;
uses crt; 

CONST 
valorAlto = 9999;
n = 3;

type

fallecido = record
	matricula: string;
	fecha: string;
	hora:string;
	lugar:string;
end;

dead = record
	nro: integer;
	dni: string[8];
	nombre:string;
	datos: fallecido;
end;

alive = record
	nro: integer;
	nombre: string;
	direccion:	string;
	matricula:	string;
	nombreM:	string;
	dniM:	string;
	nombreP:	string;
	dniP:	string;
end;

cMaestro = record
	datos: alive;
	seMurio: boolean;
	enEfecto: fallecido;
end;

maestro = file of cMaestro; // lo tengo que crear

detalleVIVO = file of alive;
detalleMUERTO = file of dead;

arrayVIVO =array [1..n] of detalleVIVO;
arrayMUERTO = array [1..n] of detalleMUERTO;

arrayRV = array [1..n] of alive;
arrayRM = array [1..n] of dead;


procedure leerVIVO (var arc_detalle: detalleVIVO ; var dato:alive);
begin
	if not eof (arc_detalle) then
		read (arc_detalle,dato)
	else
		dato.nro:= valorAlto;
end;

procedure leerMUERTO (var arc_detalle: detalleMUERTO; var dato:dead);
begin
	if not eof (arc_detalle) then
		read (arc_detalle,dato)
	else
		dato.nro:= valorAlto;
end;

procedure imprimirMas (m:cMaestro);
begin
	with m do begin
		writeln ('|NRO: ',datos.nro,' |NOMBRE: ',datos.nombre,' |DIRECCION: ',datos.direccion,' |MATRICULA: ',datos.matricula);
		writeln ('NOMBRE MADRE: ',datos.nombreM,' |DNI MADRE: ',datos.dniM,' |NOMBRE PADRE: ', datos.nombreP,'| DNI PADRE: ', datos.dniP);
		writeln ('ESTA MUERTO?: ', seMurio,' |MATRICULA MEDICO: ', enEfecto.matricula);
		writeln ('FECHA: ', enEfecto.fecha,' |HORA DE FALLECIMIENTO: ',enEfecto.hora,' |LUGAR DE FALLECIMIENTO: ',enEfecto.lugar);
		writeln ('');
	end;
end;

procedure mostrarMaestro (var arc_maestro:maestro);
var
m:cMaestro;
begin
	reset (arc_maestro);
	while not eof (arc_maestro) do begin
		read (arc_maestro,m);
		imprimirMas(m);
	end;
	close (arc_maestro);
end;

procedure getVivoMinimo(var detaVIVO: arrayVIVO; var regVIVO: arrayRV; var minVIVO:alive);
var
    i, min_index:integer;

begin
    //comparo cada registro de regVIVO para buscar el mínimo
    min_index:=0;
    minVIVO.nro:=valorAlto;
    for i:=1 to N do
        if(regVIVO[i].nro <> valorAlto) then //si el elemento i en regVIVO tiene valor alto, es porque hemos llegado al final del detalle i
            if(regVIVO[i].nro < minVIVO.nro) then begin//si es de menor nro
                minVIVO := regVIVO[i];
                min_index:=i;
            end;

    if(min_index <> 0) then
        leerVIVO(detaVIVO[min_index], regVIVO[min_index]); 
    
    //si veo que el registro mínimo ahora es el de índice 5, entonces tengo que avanzar en la lectura del detalle 5, actualizar el registro dentro de Recs y devolver en min lo que encontré al inicio
end;

procedure getMuertoMinimo(var detaMUERTO: arrayMUERTO; var regMUERTO: arrayRM; var minMUERTO:dead);
var
    i, min_index:integer;

begin
    //comparo cada registro de regVIVO para buscar el mínimo
    min_index:=0;
    minMUERTO.nro:=valorAlto;
    for i:=1 to N do
        if(regMUERTO[i].nro <> valorAlto) then //si el elemento i en regVIVO tiene valor alto, es porque hemos llegado al final del detalle i
            if(regMUERTO[i].nro < minMUERTO.nro) then begin//si es de menor nro
                minMUERTO := regMUERTO[i];
                min_index:=i;
            end;

    if(min_index <> 0) then
        leerMUERTO(detaMUERTO[min_index], regMUERTO[min_index]); 
    
    //si veo que el registro mínimo ahora es el de índice 5, entonces tengo que avanzar en la lectura del detalle 5, actualizar el registro dentro de Recs y devolver en min lo que encontré al inicio
end;


procedure crearMaestro(var arc_maestro: maestro; var detaVIVO: arrayVIVO; var detaMUERTO: arrayMUERTO; var regVIVO: arrayRV; var regMUERTO: arrayRM);
var
    minVIVO: alive;
    minMUERTO: dead;
    i: integer;
    aux: cMaestro;
    noFallecido:fallecido;

begin
    noFallecido.matricula:='';
    noFallecido.fecha:='';
    noFallecido.hora:='';
    noFallecido.lugar:='';

    rewrite(arc_maestro);
    for i:=1 to n do begin //posicionamos cada detalle al inicio
        reset(detaVIVO[i]);
        reset(detaMUERTO[i]);
        leerVIVO(detaVIVO[i], regVIVO[i]); 
        leerMUERTO(detaMUERTO[i], regMUERTO[i]); 
    end;

    getVivoMinimo(detaVIVO, regVIVO, minVIVO);//todos nacieron, pero no todos murieron, por eso recorro principalmente en los vivos
    //minMUERTO.nro:=-5;//para que la primera vez lea el primero muerto, pero las siguientes veces pueda no entrar al while. Si no pongo esto debería poner un getMuertoMinimo arriba del while, lo que haría que siempre por lo menos avance en 1 muerto (cosa que no hay que hacer si el anterior no murió)
    getMuertoMinimo(detaMUERTO, regMUERTO, minMUERTO);//da los mismos resultados que hacer lo de arriba
    while(minVIVO.nro <> valorAlto) do begin
        //las personas no se repiten
        aux.datos:= minVIVO;
        //veo si murio para completar más la informacion
        while(minMUERTO.nro < minVIVO.nro) do begin//si me paso puede ser porque no murió o por llegar al final con el valor alto
            getMuertoMinimo(detaMUERTO, regMUERTO, minMUERTO);
        end;

        if(minMUERTO.nro = minVIVO.nro) then begin
            aux.seMurio:=true;
            aux.enEfecto :=minMUERTO.datos;
        end
        else begin
            aux.seMurio:=false;
            aux.enEfecto:=noFallecido;
        end;
        //no hay que retroceder en el maestro porque el maestro estaba vacío
        write(arc_maestro, aux);
        getVivoMinimo(detaVIVO, regVIVO, minVIVO); //no olvidar de avanzar
    end;

    close(arc_maestro);
    for i:=1 to n do begin //posicionamos cada detalle al inicio
        close(detaVIVO[i]);
        close(detaMUERTO[i]);
    end;
end;

//otra forma diferente de hacerlo
procedure crearMaestro2 (var arc_maestro: maestro; var detaVIVO:arrayVIVO; var detaMUERTO: arrayMUERTO; var regVIVO: arrayRV; var regMUERTO: arrayRM);
var
minV: alive;
minM: dead;
m:cMaestro;
i:integer;
aString:string;
begin
	rewrite (arc_maestro);
	for i:= 1 to n do begin 
		Str (i,aString);
		Assign (detaVIVO[i],'detalleVIVO'+aString);
		reset (detaVIVO[i]);
		leerVIVO (detaVIVO[i],regVIVO[i]);
		Assign (detaMUERTO[i],'detalleMUERTO'+aString);
		reset (detaMUERTO[i]);
		leerMUERTO (detaMUERTO[i],regMUERTO[i]);
	end;
	getVivoMinimo (detaVIVO,regVIVO,minV);
	getMuertoMinimo (detaMUERTO,regMUERTO,minM);
	writeln (minV.nro,minM.nro);
	while (minV.nro <> valorAlto) do begin
		if (minV.nro = minM.nro) then begin
			m.seMurio:= true;
			m.enEfecto:= minM.datos;
			getMuertoMinimo (detaMUERTO,regMUERTO,minM);
		end
		else begin
			m.seMurio:= false;
			m.enEfecto.matricula:='';
			m.enEfecto.fecha:='';
			m.enEfecto.hora:='';
			m.enEfecto.lugar:='';
		end;
		m.datos:= minV;
		write (arc_maestro,m);
		getVivoMinimo (detaVIVO,regVIVO,minV);
	end;
	close (arc_maestro);
	for i:= 1 to n do 
		close (detaVIVO[i]);
		close (detaMUERTO[i]);
end;

var
arc_maestro: maestro;
detaVIVO: arrayVIVO;
detaMUERTO: arrayMUERTO;
regVIVO: arrayRV;
regMUERTO: arrayRM;
i: integer;
str_aux:string;

begin
	Assign (arc_maestro,'maestro');
    for i:=1 to n do begin
        Str(i, str_aux);
        assign(detaVIVO[i], 'detalleVIVO'+str_aux);
        assign(detaMUERTO[i], 'detalleMUERTO'+str_aux);
    end;
	crearMaestro (arc_maestro,detaVIVO,detaMUERTO,regVIVO,regMUERTO);
	mostrarMaestro (arc_maestro);
end.

