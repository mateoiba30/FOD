program ej12;

CONST
valorAlto = 9999;

type
    cMaestro = record
        nro_usuario:integer;
        nombreUsuario:string;
        nombre:string;
        apellido:string;
        cantMail:integer;
    end;

    cDetalle = record
        nro_usuario:integer;
        cuentaDestino:string;
        cuerpo:string;
    end;

    maestro = file of cMaestro;
    detalle = file of cDetalle;

procedure leer (var arc_detalle:detalle; var dato:cDetalle);
begin
	if not eof (arc_detalle) then
		read (arc_detalle,dato)
	else
		dato.nro_usuario:= valorAlto;
end;

procedure leerMaestro(var arc_maestro: maestro; var datoMaestro: cMaestro);
begin
    if not eof(arc_maestro) then
        read(arc_maestro, datoMaestro)
    else
        datoMaestro.nro_usuario := valorAlto;
end;

procedure actualizarEInformar (var arc_maestro:maestro; var arc_detalle:detalle; var arcTxt:Text);
var
    dato:cDetalle;
    datoMaestro: cMaestro;
    envios_usuario, nro_usuario_act:integer;

begin
    reset(arc_maestro);
    rewrite(arcTxt);
    reset(arc_detalle);

    leer(arc_detalle , dato);
    while(dato.nro_usuario <> valorAlto) do begin //para todo el detalle
        envios_usuario:=0;
        nro_usuario_act := dato.nro_usuario;
        while(dato.nro_usuario = nro_usuario_act) do begin //para cada usuario
            envios_usuario += 1;
            leer(arc_detalle, dato);
        end;
        
        //ahora actualizo el maestro para el inciso a)
        leerMaestro(arc_maestro, datoMaestro);
        while(datoMaestro.nro_usuario <> valorAlto) and (datoMaestro.nro_usuario <> nro_usuario_act) do //tal vez no exista el usuario en el maestro
            leerMaestro(arc_maestro, datoMaestro);

        if datoMaestro.nro_usuario = nro_usuario_act then begin
            datoMaestro.cantMail += envios_usuario;
            seek(arc_maestro, filepos(arc_maestro)-1);
            write(arc_maestro, datoMaestro);
        end;

        //ahora informo lo del día para el inciso b)
        writeln(arcTxt, nro_usuario_act, '.............', envios_usuario);
    end;
    close(arc_maestro);
    close(arc_detalle);
    close(arcTxt);
end;

var
arc_maestro:maestro;
arc_detalle:detalle;
arcTxt:Text;
begin
	Assign (arc_maestro,'logmail.dat');
	Assign (arc_detalle,'detalle');
	Assign (arcTxt,'informe.txt');
	actualizarEInformar (arc_maestro,arc_detalle,arcTxt);
end.