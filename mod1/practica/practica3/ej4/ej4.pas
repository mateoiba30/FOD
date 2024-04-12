program ej4;

const
    valorAlto = 9999;
    FIN = '@fin';

type
    reg_flor = record
        nombre: string[45];
        codigo: integer;
    end;

    tArchFlores = file of reg_flor;

procedure leer(var a1: tArchFlores; var flor: reg_flor);
begin
    if(not eof(a1))then   
        read(a1, flor)
    else
        flor.codigo := valorAlto;
end;

function existeCodigo(var a1: tArchFlores; cod:integer; pos: integer):boolean;
var
    flor:reg_flor;
    existe:boolean;
begin
    existe := false;
    reset(a1);

    leer(a1, flor);
    while(flor.codigo <> valorAlto) do begin
        if(flor.codigo = cod) then begin
            existe := true;
            break;
        end;
        leer(a1, flor);
    end;

    existeCodigo := existe;
    seek(a1, pos);
end;


procedure crearArchivo(var a1: tArchFlores);
var
    flor: reg_flor;

begin
    rewrite(a1);

    flor.nombre := ' ';
    flor.codigo := 0;
    //le agrego más información, porque si justo había un número basura donde espero texto entonces la compu piensa que es un archivo binario en lugar de un txt
    write(a1, flor); //ponemos el registro cabecera

    write('Ingrese el nombre de la flor (ingrese "', FIN,'" para terminar): ');
    readln(flor.nombre);
    while(flor.nombre <> FIN) do begin
        write('Ingrese el codigo de la flor: ');
        readln(flor.codigo);

        if( existeCodigo(a1, flor.codigo, filePos(a1))) then begin
            writeln('El codigo ya existe, pruebe con otro');
            continue;
        end;

        write(a1, flor);
        writeln('');
        write('Ingrese el nombre de otra flor: ');
        readln(flor.nombre);
    end;

    writeln('Archivo creado en el nombre indicado');
    close(a1);
end;

procedure listarCompleto(var a1: tArchFlores);
var
    flor: reg_flor;

begin
    reset(a1);

    writeln('codigo | nombre');
    leer(a1, flor);
    while(flor.codigo <> valorAlto) do begin
        writeln(flor.codigo, ' | ', flor.nombre);
        leer(a1, flor);
    end;

    close(a1);
end;

procedure agregarFlor(var a1: tArchFlores);
var
    flor, libre, cabecera:reg_flor;
    codigoValido:boolean;

begin
    reset(a1);
    read(a1, cabecera);

    write('Ingrese el nombre de la flor: ');
    readln(flor.nombre);
    write('Ingrese el codigo de la flor: ');
    readln(flor.codigo);

    codigoValido := false;
    while(codigoValido = false) do begin
        if( existeCodigo(a1, flor.codigo, filePos(a1))) then begin
            write('El codigo ya existe, pruebe con otro: ');
            readln(flor.codigo);
        end
        else begin
            codigoValido := true;
        end;
    end;

    if(cabecera.codigo = 0) then begin //si no hay espacio lógcio, escribir al final
        seek(a1, fileSize(a1));
        write(a1, flor);
    end
    else begin
        seek(a1, -1*cabecera.codigo); //voy al espacio libre que indica la cabecera
        read(a1, libre);
        seek(a1, filePos(a1)-1);//vuelvo hacia atrás para sobreescribir el espacio libre logico
        write(a1, flor);
        seek(a1, 0);
        write(a1, libre); //ahora la cabecera apunta al siguiente espacio libre
    end;
    writeln('Flor argegada');
end;

procedure eliminarFlor(var a1: tArchFlores);
var
    cod:integer;
    flor, cabecera:reg_flor;
    eliminado: boolean;

begin
    reset(a1);

    write('Ingrese el codigo de la flor a eliminar: ');
    readln(cod);
    leer(a1, flor);
    cabecera := flor; //el primer registro es la cabecera

    eliminado:=false;
    while ((flor.codigo <> valorAlto) and (not eliminado)) do begin //el archivo puede no estar ordenado
        if(flor.codigo = cod) then begin
            flor.codigo := cabecera.codigo; //nov.cod tiene que apuntar a lo que apuntaba la cabecera
            seek(a1, filePos(a1)-1); //me paro al inicio de la novela a borrar
            cabecera.codigo := -1*filePos(a1); //la cabecera apuntar a esta novela

            write(a1, flor); //guardo los cambios
            seek(a1, 0);
            write(a1, cabecera);
            eliminado:= true;
        end
        else begin
            leer(a1, flor);
        end;
    end;

    if(eliminado) then
        writeln('Flor eliminada')
    else
        writeln('Flor no eliminada, no se encontro el codigo');

    close(a1);
end;

procedure listarSinEliminados(var a1: tArchFlores);
var
    flor: reg_flor;

begin
    reset(a1);
    seek (a1,1); //me salteo el registro cabecera
    writeln('codigo | nombre');
    leer(a1, flor);
    while(flor.codigo <> valorAlto) do begin
        if(flor.codigo > 0) then
            writeln(flor.codigo, ' | ', flor.nombre);
        leer(a1, flor);
    end;

    close(a1);
end;

var
    a1: tArchFlores;
    nombre_fisico: string;

begin
    write('Ingrese el nombre del ARCHIVO BINARIO a manipular: ');
    readln(nombre_fisico);
    assign(a1, nombre_fisico);

    crearArchivo(a1);
    eliminarFlor(a1);
    eliminarFlor(a1);
    listarCompleto(a1);
    agregarFlor(a1);
    listarCompleto(a1);
    listarSinEliminados(a1);
    
end.