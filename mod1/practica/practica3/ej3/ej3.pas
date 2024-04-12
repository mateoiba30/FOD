program ej3;

uses crt;

const   
    valorAlto = 9999;
    FIN = '@fin';

type
    novela=record
        cod, duracion:integer;
        genero, nombre, director:string;
        precio:double;
    end;

    archivo_novelas = file of novela;

procedure leer(var a1: archivo_novelas; var nov:novela);
begin
    if(not eof(a1))then   
        read(a1, nov)
    else
        nov.cod := valorAlto;
end;

function existeCodigo(var a1: archivo_novelas; cod:integer; pos: integer):boolean;
var
    nov:novela;
    existe:boolean;
begin
    existe := false;
    reset(a1);

    leer(a1, nov);
    while(nov.cod <> valorAlto) do begin
        if(nov.cod = cod) then begin
            existe := true;
            break;
        end;
        leer(a1, nov);
    end;

    existeCodigo := existe;
    seek(a1, pos);
end;

procedure crearArchivo(var a1: archivo_novelas);
var
    nov:novela;

begin
    rewrite(a1);

    nov.cod := 0;
    nov.duracion := 0;
    nov.genero := ' ';
    nov.nombre := ' ';
    nov.director := ' ';
    nov.precio := 0.0;
    //le agrego más información, porque si justo había un número basura donde espero texto entonces la compu piensa que es un archivo binario en lugar de un txt
    write(a1, nov); //ponemos el registro cabecera

    write('Ingrese el nombre de la novela (ingrese "', FIN,'" para terminar): ');
    readln(nov.nombre);
    while(nov.nombre <> FIN) do begin
        write('Ingrese el codigo de la novela: ');
        readln(nov.cod);

        if( existeCodigo(a1, nov.cod, filePos(a1))) then begin
            writeln('El codigo ya existe, pruebe con otro');
            continue;
        end;

        write('Ingrese la duracion de la novela: ');
        readln(nov.duracion);
        write('Ingrese el genero de la novela: ');
        readln(nov.genero);
        write('Ingrese el director de la novela: ');
        readln(nov.director);
        write('Ingrese el precio de la novela: ');
        readln(nov.precio);

        write(a1, nov);
        writeln('');
        write('Ingrese el nombre de otra novela: ');
        readln(nov.nombre);
    end;

    writeln('Archivo creado en el nombre indicado');
    close(a1);
end;

procedure exportarTecnicamenteNovelas(var a1: archivo_novelas;  var txt: Text);
var
    nov: novela;

begin
    reset(a1);
    rewrite(txt);

    writeln(txt, 'codigo | duracion | genero | nombre | director | precio');
    leer(a1, nov);
    while(nov.cod <> valorAlto) do begin
        writeln(txt, nov.cod, ' ', nov.duracion, ' ', nov.genero, ' ', nov.nombre, ' ', nov.director, ' ', nov.precio:2:2);
        leer(a1, nov);
    end;

    writeln('Informacion guardada en el archivo ./novelas.txt');
    close(a1);
    close(txt);
end;

procedure agregarNovela(var a1: archivo_novelas);
var
    nov, libre, cabecera:novela;
    codigoValido:boolean;

begin
    reset(a1);
    read(a1, cabecera);

    write('Ingrese el nombre de la novela: ');
    readln(nov.nombre);
    write('Ingrese el codigo de la novela: ');
    readln(nov.cod);

    codigoValido := false;
    while(codigoValido = false) do begin
        if( existeCodigo(a1, nov.cod, filePos(a1))) then begin
            writeln('El codigo ya existe, pruebe con otro: ');
            readln(nov.cod);
        end
        else begin
            codigoValido := true;
        end;
    end;

    write('Ingrese la duracion de la novela: ');
    readln(nov.duracion);
    write('Ingrese el genero de la novela: ');
    readln(nov.genero);
    write('Ingrese el director de la novela: ');
    readln(nov.director);
    write('Ingrese el precio de la novela: ');
    readln(nov.precio);

    if(cabecera.cod = 0) then begin //si no hay espacio lógcio, escribir al final
        seek(a1, fileSize(a1));
        write(a1, nov);
    end
    else begin
        seek(a1, -1*cabecera.cod); //voy al espacio libre que indica la cabecera
        read(a1, libre);
        seek(a1, filePos(a1)-1);//vuelvo hacia atrás para sobreescribir el espacio libre logico
        write(a1, nov);
        seek(a1, 0);
        write(a1, libre); //ahora la cabecera apunta al siguiente espacio libre
    end;
    writeln('Novela argegada');
end;

procedure eliminarNovela(var a1: archivo_novelas);
var
    cod:integer;
    nov, cabecera:novela;
    eliminado: boolean;

begin
    reset(a1);

    write('Ingrese el codigo de la novela a eliminar: ');
    readln(cod);
    leer(a1, nov);
    cabecera := nov; //el primer registro es la cabecera

    eliminado:=false;
    while ((nov.cod <> valorAlto) and (not eliminado)) do begin //el archivo puede no estar ordenado
        if(nov.cod = cod) then begin
            nov.cod := cabecera.cod; //nov.cod tiene que apuntar a lo que apuntaba la cabecera
            seek(a1, filePos(a1)-1); //me paro al inicio de la novela a borrar
            cabecera.cod := -1*filePos(a1); //la cabecera apuntar a esta novela

            write(a1, nov); //guardo los cambios
            seek(a1, 0);
            write(a1, cabecera);
            eliminado:= true;
        end
        else begin
            leer(a1, nov);
        end;
    end;

    if(eliminado) then
        writeln('Novela eliminada')
    else
        writeln('Novela no eliminada, no se encontro el codigo');

    close(a1);
end;

procedure exportarVisualmenteNovelas (var arc_log:archivo_novelas; var arcTxt: Text);
var
    n:novela;
begin
	reset (arc_log);
	rewrite (arcTxt);
	seek (arc_log,1); // me salteo el cabecera
	leer(arc_log,n);
	while (n.cod <> valorAlto) do begin
		with n do begin
			if (cod > 0) then
				writeln (arcTxt,'CODIGO: ',cod,' NOMBRE: ',nombre,' GENERO: ',genero,' DIRECTOR: ',director,' DURACION: ',duracion,' PRECIO: ',precio:1:1)
			else
				writeln (arcTxt,'ESPACIO LIBRE');
		end;
		leer(arc_log,n);
	end;
	close (arc_log);
	close(arcTxt);
end;

var
    a1: archivo_novelas;
    nombre_fisico:string;
    terminar:boolean;
    opcion:integer;
    arcTxt: Text;

begin
    assign (arcTxt,'novelas.txt');

    write('Ingrese el nombre del ARCHIVO BINARIO a manipular: ');
    readln(nombre_fisico);
    assign(a1, nombre_fisico);

    terminar:=false;
    while(terminar=false) do begin
        writeln('Ingrese una de las siguientes opciones:');
        writeln('0: FINALIZAR');
        writeln('1: crear archivo'); //como lista invertida
        writeln('2: agregar novela'); //aprovechando las eliminaciones lógicas
        writeln('3: modificar novela'); //no se puede modificar el codigo de novela
        writeln('4: eliminar novela'); //eliminar lógicamente -> dejar el resto de la info intacta para poder recuperarla
        writeln('5: exportar novelas de forma estetica'); //incluir las eliminadas logicamente
        writeln('6: exportar novelas de forma tecnica');

        readln(opcion);

        case opcion of
            0:terminar := true;
            1:crearArchivo(a1);
            2: agregarNovela(a1);

            4: eliminarNovela(a1);
            5: exportarVisualmenteNovelas(a1, arcTxt);
            6: exportarTecnicamenteNovelas(a1, arcTxt); //si no paso el txt como parametro entonces no se guardan los cambios
        end;
    end;

end.