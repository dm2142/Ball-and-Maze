library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

entity BallAndMaze is

	port(
		CLK		: in STD_LOGIC;		-- Entrada del reloj maestro principal
		RST		: in STD_LOGIC;		-- Reinicio de todas las entidades
		H		: in STD_LOGIC;		-- Habilitador de todas las entidades
		
		BOTON_START		: in std_logic;		-- Reinicio de todas las entidades
		LIMIT_SWITCH	: in std_logic;		-- Habilitador de todas las entidades
		BOTON_RST		: in std_logic;
		
		POS_SERVO_X : in std_logic_vector(7 downto 0);
		POS_SERVO_Y : in std_logic_vector(7 downto 0);
		
		SERVO_X: out std_logic;
		SERVO_Y: out std_logic;
		
		BdT_ADC1 : out std_logic ; 	-- Salida para la base de tiempo del ADC0804
		BdT_ADC2 : out std_logic ; 	-- Salida para la base de tiempo del ADC0804 
		
		PWM 	 : out std_logic ; 	-- Salida para la base del tiempo del PWM
		
		DISPLAY0 	: out STD_LOGIC_VECTOR(7 downto 0);		--	Salida con la cuenta actual al correspondiente LED del display.
		DISPLAY1 	: out STD_LOGIC_VECTOR(7 downto 0);		--	Salida con la cuenta actual al correspondiente LED del display.
		DISPLAY2 	: out STD_LOGIC_VECTOR(7 downto 0);		--	Salida con la cuenta actual al correspondiente LED del display.
		DISPLAY3 	: out STD_LOGIC_VECTOR(7 downto 0);		--	Salida con la cuenta actual al correspondiente LED del display.	
		DISPLAY4 	: out STD_LOGIC_VECTOR(7 downto 0);		--	Salida con la cuenta actual al correspondiente LED del display.
		DISPLAY5 	: out STD_LOGIC_VECTOR(7 downto 0)		--	Salida con la cuenta actual al correspondiente LED del display.
	);	 
	
end BallAndMaze; 

architecture Complete of BallAndMaze is

-- Se�ales para las diferentes bases de tiempo utilizadas.
signal s_clk_1s: std_logic := '0';
signal s_clk_10ms: std_logic := '0';
signal s_clk_100ms: std_logic := '0';
signal signal_256kHz: std_logic :='0';
signal signal_100Hz: std_logic :='0';
signal signal_128kHz: std_logic := '0';

signal ADC: std_logic := '0';
signal START: std_logic := '0';
signal RST_CONTADOR: std_logic := '0';

-- Se�alas para llevar la cuenta de cada d�gito.
signal COUNT0 		: STD_LOGIC_VECTOR(3 downto 0) := (others =>'0'); 
signal COUNT1 		: STD_LOGIC_VECTOR(3 downto 0) := (others =>'0'); 
signal COUNT2 		: STD_LOGIC_VECTOR(3 downto 0) := (others =>'0');
signal COUNT3 		: STD_LOGIC_VECTOR(3 downto 0) := (others =>'0');
signal COUNT4 		: STD_LOGIC_VECTOR(3 downto 0) := (others =>'0');
signal COUNT5 		: STD_LOGIC_VECTOR(3 downto 0) := (others =>'0');

signal FLAG0		: STD_LOGIC := '0';
signal FLAG1		: STD_LOGIC := '0';
signal FLAG2		: STD_LOGIC := '0';
signal FLAG3		: STD_LOGIC := '0';

begin 
	
	BdT_ADC1 <= ADC;
	BdT_ADC2 <= ADC;
	
	-- Uso de botones
	BT_U1: entity work.SwitchBoton port map(BOTON_START, START);
	BT_U2: entity work.BotonGenerico port map(CLK, BOTON_RST, RST_CONTADOR);
		
	-- Entidades para el cron�metro
	-- Generar las bases de tiempo adecuadas.  
	CLK_O1: entity work.Generic_Clock generic map(249980) port map( CLK, RST, H, s_clk_10ms ); -- 10  ms
	CLK_O2: entity work.Generic_Clock generic map(2499940) port map( CLK, RST, H, s_clk_100ms );	-- 100 ms
	CLK_U1: entity work.Generic_Clock generic map(25000000) port map( CLK, RST, H, s_clk_1s );	-- 1 s 	
		
	-- Entidades para los contadores
	CLK_O7: entity work.Contador9 port map(s_clk_10ms, RST, COUNT0); -- Cuenta cada 10 ms	
	CLK_O8: entity work.Contador9 port map(s_clk_100ms, RST, COUNT1); -- Cuenta cada 100 ms
	CLK_U2: entity work.Contador9_alt port map(s_clk_1s, RST, H, COUNT2, FLAG0);		
	CLK_U3: entity work.Contador5_alt port map(FLAG0, RST, H, COUNT3, FLAG1);		
	CLK_U4: entity work.Contador9_alt port map(FLAG1, RST, H, COUNT4, FLAG2);		
	CLK_U5: entity work.Contador5_alt port map(FLAG2, RST, H, COUNT5, FLAG3);		
	
	-- Entidades para mostrar el n�mero en su respectivo  display
	
	CLK_U6: entity work.DisplaySieteSegmentos port map(COUNT0, DISPLAY0);
	CLK_U7: entity work.DisplaySieteSegmentos port map(COUNT1, DISPLAY1);
	CLK_U8: entity work.DisplaySieteSegmentos port map(COUNT2, DISPLAY2);
	CLK_U9: entity work.DisplaySieteSegmentos port map(COUNT3, DISPLAY3);
	CLK_U10: entity work.DisplaySieteSegmentos port map(COUNT4, DISPLAY4);
	CLK_U11: entity work.DisplaySieteSegmentos port map(COUNT5, DISPLAY5);
	
	-- Entidades para el uso de la se�al PWM
	
	PWM_U1: entity work.clk256kHz port map( CLK, RST, signal_256kHz);
	PWM_U2: entity work.Generic_Clock generic map(500000) port map( CLK, RST, H, signal_100Hz );
	PWM_U3: entity work.PWM_Signal port map(signal_256kHz, signal_100Hz, RST,PWM);
	
	-- Entidades para el uso del ADC0804	
	ADC_U1: entity work.Generic_Clock generic map(1000000) port map( CLK, RST, H, ADC );
		
	-- Entidades para el uso del Control de servo
	SERVO_U1: entity work.clk128kHz port map( CLK, RST, signal_128kHz);
	SERVO_U2: entity work.servo_signal port map( signal_128kHz, RST, POS_SERVO_X, SERVO_X );
	SERVO_U3: entity work.servo_signal port map( signal_128kHz, RST, POS_SERVO_Y, SERVO_Y );
		
end architecture Complete;