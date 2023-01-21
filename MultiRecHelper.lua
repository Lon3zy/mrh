script_name('MultiRecHelper')
script_author('Kalgon')
script_moonloader('026')

pcall(require, 'moonloader')
pcall(require, 'lib.sampfuncs')
local dlstatus = require("moonloader").download_status
local font_flag = require('moonloader').font_flag
local limgui, imgui = pcall(require, 'imgui')
local sampev, sp = pcall(require, 'lib.samp.events')
local sbitsit, bitsio = pcall(require, 'lib.samp.events.bitstream_io')
local leff, effil = pcall(require, "effil")
local lmem, memory = pcall(require, 'memory')
local lkey, key = pcall(require, "vkeys")
local bwm, wm = pcall(require, 'lib.windows.message')
local lini, inicfg = pcall(require, 'inicfg')
local resirc, irctable = pcall(require, 'luaircv2')
local bfa, fa = pcall(require, 'fAwesome5')
--local lib, requests = pcall(require, 'requests')
local brk, rkeys = pcall(require, 'rkeys')
local bhk, hk = pcall(require, 'lib.imcustom.hotkey')

local rkeysdownload = false

local lecod, encoding = pcall(require, 'encoding')
encoding.default = 'CP1251'
u8 = encoding.UTF8

local jsonDir = getWorkingDirectory().."\\config\\MRH\\presets.json"
local jsonDir2 = getWorkingDirectory().."\\config\\MRH\\logs.json"

local cfg1 = {
    presets = {
        weather = {
            {'Стандартная',-1 , -1}
        }
    }
}

local cfg2 = {
    logs = {
        klad = {
            
        },
		script = {

		}
    }
}

local cfg = {
	config={
		parol='';
		time_restart='09:05:00';
		auto_login=false;
		auto_pincod=false;
		rec_restart=false;
		home_lock=false;
		klad_find=false;
		lock_car=false;
		arzlaun=false;
		a_afk=false;
		vk_pay_day=false;
		vk_init_game=false;
		vk_crash_game=false;
		vk_notf=false;
		vk_listen=false;
		spass=false;
		answer_k=false;
		key_c=false;
		chat_trash=false;
		dialog_trash=false;
		max_speed=false;
		max_speedped=false;
		olock_c=false;
		phone=false;
		calc=false;
		jlock_car=false;
		changescr=false;
		tcmd=false;
		bhop=false;
		chack=false;
		textClr1=1.00;
		textClr2=1.00;
		textClr3=1.00;
		textClr4=1.00;
		FrameBg1=0.21;
		FrameBg2=0.20;
		FrameBg3=0.21;
		FrameBg4=0.60;
		TitleBg1=0.00;
		TitleBg2=0.46;
		TitleBg3=0.65;
		TitleBg4=1.00; 
		WindowBg1=0.11;
		WindowBg2=0.10;
		WindowBg3=0.11;
		WindowBg4=1.00; 
		colortime1=0.00;
		colortime2=0.00;
		colortime3=0.00;
		colortext1=1.00;
		colortext2=1.00;
		colortext3=1.00;
		pincod='';
		nick_name='';
		userid='';
		colort='{ffffff}';
		autinfo=false;
		setw=-1;
		sett=-1;
		timeX=290;
		timeY=100;
		timeHeight=30;
		timeVar=0;
		timeFont=0;
		phoneint=0;
		infrun=false;
		timedraw=false;
		savedialog=false;
		tracerklad=false;
		vipchat=false;
		kystibool=false;
		autohawk=false;
		autohawkafk=false;
		binder=false;
		autochest=false;
		antilomka=false;
		checkmethod=0;
		eat2met=30;
		eatmetod=0;
		healstate=false;
		vkcheststart=false;
		autobike=false;
		hplvl=30;
		hpmetod=0;
		clrtext=-1,
	},
	statTimers = {
    	state = true,
    	clock = true,
    	sesOnline = true,
    	sesAfk = true, 
    	sesFull = true,
  		dayOnline = true,
  		dayAfk = true,
  		dayFull = true,
  		weekOnline = true,
  		weekAfk = true,
  		weekFull = true,
        server = nil
    },
	onDay = {
		today = os.date("%a"),
		online = 0,
		afk = 0,
		full = 0
	},
	onWeek = {
		week = 1,
		online = 0,
		afk = 0,
		full = 0
	},
    myWeekOnline = {
        [0] = 0,
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0,
        [6] = 0
    },
    pos = {
        x = 0,
        y = 0
    },
    style = {
    	round = 10.0,
    	colorW = 4279834905,
    	colorT = 4286677377
    }
}
local d_ini = "..\\config\\MultiRec.ini"
local ini = inicfg.load(cfg, d_ini)

local file = getWorkingDirectory() .. "\\config\\MRH\\binds.bind"
local tEditData = {
	id = -1,
	inputActive = false
}
local sInputEdit = imgui.ImBuffer(128)
local bIsEnterEdit = imgui.ImBool(false)

if bhk then
	hk._SETTINGS.noKeysMessage = u8("Пусто")
end

local tBindList = {}
if doesFileExist(file) then
	local f = io.open(file, "r")
	if f then
		tBindList = decodeJson(f:read("a*"))
		f:close()
	end
else
	tBindList = {
		[1] = {
			text = "/armour",
			v = {key.VK_MENU, key.VK_1}
		},
		[2] = {
			text = "/trade {nearest_id}",
			v = {key.VK_MENU, key.VK_2}
		},
		[3] = {
			text = "/usedrugs 3",
			v = {key.VK_MENU, key.VK_3}
		},
		[4] = {
			text = "/mask",
			v = {key.VK_MENU, key.VK_4}
		}
	}
end

local textClr = imgui.ImFloat4(ini.config.textClr1, ini.config.textClr2, ini.config.textClr3, ini.config.textClr4)
local FrameBg = imgui.ImFloat4(ini.config.FrameBg1, ini.config.FrameBg2, ini.config.FrameBg3, ini.config.FrameBg4)
local TitleBg = imgui.ImFloat4(ini.config.TitleBg1, ini.config.TitleBg2, ini.config.TitleBg3, ini.config.TitleBg4)
local WindowBg = imgui.ImFloat4(ini.config.WindowBg1, ini.config.WindowBg2, ini.config.WindowBg3, ini.config.WindowBg4)
local colortime = imgui.ImFloat3(ini.config.colortime1, ini.config.colortime2, ini.config.colortime3)

local colortext = imgui.ImFloat3(ini.config.colortext1, ini.config.colortext2, ini.config.colortext3)

tr = {
	reloadR = false,
	ruletka = false,
	dbug = false,
	ifix = false,
	homejoinbool = false,
	clickupd = true,
	clickarz = true,
	clickarzvoice = false,
	image = nil,
	isEnableklad = false,
	isEnableklad_new = false,
	isEnablenarko = false,
	openStartChest = imgui.ImBool(false),
}

igvars = {
	main_window_state = imgui.ImBool(false),
	new_report = imgui.ImBool(false),
	input_report = imgui.ImBuffer(256),
	save_report = imgui.ImInt(1),
    alert_window_state = imgui.ImBool(false),
    black_window_state = imgui.ImBool(false),
    window_calc = imgui.ImBool(false),
	window_vkoin = imgui.ImBool(false),
	window_push = imgui.ImBool(false),
	isEnableklad = imgui.ImBool(false),
	isEnableklad_new = imgui.ImBool(false),
	isEnablenarko = imgui.ImBool(false),
	tsr_informer = imgui.ImBool(false),
	fpscr = imgui.ImBool(false),
	removecar = imgui.ImBool(false),
    auto_l = imgui.ImBool(ini.config.auto_login),
    auto_p = imgui.ImBool(ini.config.auto_pincod),
    pass_w = imgui.ImBuffer(''..ini.config.parol, 500),
    rec_r = imgui.ImBool(ini.config.rec_restart),
    home_l = imgui.ImBool(ini.config.home_lock),
    klad = imgui.ImBool(ini.config.klad_find),
    lock_c = imgui.ImBool(ini.config.lock_car),
    arz_laun = imgui.ImBool(ini.config.arzlaun),
    aafk = imgui.ImBool(ini.config.a_afk),
    vk_payday = imgui.ImBool(ini.config.vk_pay_day),
    vk_initgame = imgui.ImBool(ini.config.vk_init_game),
    vk_crash = imgui.ImBool(ini.config.vk_crash_game),
    vknotf = imgui.ImBool(ini.config.vk_notf),
    vk_listen = imgui.ImBool(ini.config.vk_listen),
    spass = imgui.ImBool(ini.config.spass),
    answer_k = imgui.ImBool(ini.config.answer_k),
    key_c = imgui.ImBool(ini.config.key_c),
    chat_trash = imgui.ImBool(ini.config.chat_trash),
    dialog_trash = imgui.ImBool(ini.config.dialog_trash),
    max_speed = imgui.ImBool(ini.config.max_speed),
    max_speedped = imgui.ImBool(ini.config.max_speedped),
    olock_c = imgui.ImBool(ini.config.olock_c),
    phone = imgui.ImBool(ini.config.phone),
    calc = imgui.ImBool(ini.config.calc),
    jlock_car = imgui.ImBool(ini.config.jlock_car),
	changescr = imgui.ImBool(ini.config.changescr),
    tcmd = imgui.ImBool(ini.config.tcmd),
    bhop = imgui.ImBool(ini.config.bhop),
	pin_cod = imgui.ImBuffer(''..ini.config.pincod, 500),
	nick_n = imgui.ImBuffer(''..ini.config.nick_name, 500),
	user_id = imgui.ImBuffer(''..ini.config.userid, 500),
	colort = imgui.ImBuffer(''..ini.config.colort, 500),
	name_bind_weather = imgui.ImBuffer('', 500),
	autinfo = imgui.ImBool(ini.config.autinfo),
	chack = imgui.ImBool(ini.config.chack),
	setw = imgui.ImInt(ini.config.setw),
	sett = imgui.ImInt(ini.config.sett),
	timeX = imgui.ImInt(ini.config.timeX),
	timeY = imgui.ImInt(ini.config.timeY),
	timeHeight = imgui.ImInt(ini.config.timeHeight),
	timeVar = imgui.ImInt(ini.config.timeVar),
	timeFont = imgui.ImInt(ini.config.timeFont),
	phoneint = imgui.ImInt(ini.config.phoneint),
	infrun = imgui.ImBool(ini.config.infrun),
	timedraw = imgui.ImBool(ini.config.timedraw),
	savedialog = imgui.ImBool(ini.config.savedialog),
	tracerklad = imgui.ImBool(ini.config.tracerklad),
	vipchat = imgui.ImBool(ini.config.vipchat),
	kystibool = imgui.ImBool(ini.config.kystibool),
	autohawk = imgui.ImBool(ini.config.autohawk),
	autohawkafk = imgui.ImBool(ini.config.autohawkafk),
	binder = imgui.ImBool(ini.config.binder),
	autochest = imgui.ImBool(ini.config.autochest),
	antilomka = imgui.ImBool(ini.config.antilomka),
	checkmethod = imgui.ImInt(ini.config.checkmethod),
	eat2met = imgui.ImInt(ini.config.eat2met),
	eatmetod = imgui.ImInt(ini.config.eatmetod),
	healstate = imgui.ImBool(ini.config.healstate),
	vkcheststart = imgui.ImBool(ini.config.vkcheststart),
	autobike = imgui.ImBool(ini.config.autobike),
	hplvl = imgui.ImInt(ini.config.hplvl),
	hpmetod = imgui.ImInt(ini.config.hpmetod)
}

local scr_vers = 42
local scr_vers_text = "3.0"

local upd_url = "https://raw.githubusercontent.com/sawyx/mrh/main/updmrh.ini"
local upd_path = getWorkingDirectory() .. "/updmrh.ini"
local scr_url = "https://github.com/sawyx/mrh/blob/main/MultiRecHelper.luac?raw=true"
local scr_path = thisScript().path
local upd_state = false
local upd_state2 = false

local devmode = false

local dl_files = 0
local dl_status = false
local dl_status1 = false

local d_joined = true

local gotoeatinhouse = false

local bool_bike = false

local pp1, pp2 = '0', '0'

local checklist = {
	u8('You are hungry!'),
	u8('Полоска голода')
}

local healmetod = {
	u8('Бар дома'),
	u8('Наркотики')
}

local scinfo = [[
Команды скрипта:

	/mrh[F9] - Открыть меню скрипта
	/mrh.r - Перезагрузка скрипта
	//rec - Реконнект
	/testvk - Тестовое сообщение в вк
	/ifix - Фиксит инвентарь 
	/klad - Поставить метку клада на карте
	/cf - Написать в чат евреев
	/crep - Запросить форму репорта
	/cpos - Запросить геолокацию игрока
	/mshowmc - Показать фейк мед карту
	/pcar - Спавнит на автосалонах машины (для ловли)
]]

local chars = {
	["й"] = "q", ["ц"] = "w", ["у"] = "e", ["к"] = "r", ["е"] = "t", ["н"] = "y", ["г"] = "u", ["ш"] = "i", ["щ"] = "o", ["з"] = "p", ["х"] = "[", ["ъ"] = "]", ["ф"] = "a",
	["ы"] = "s", ["в"] = "d", ["а"] = "f", ["п"] = "g", ["р"] = "h", ["о"] = "j", ["л"] = "k", ["д"] = "l", ["ж"] = ";", ["э"] = "'", ["я"] = "z", ["ч"] = "x", ["с"] = "c", ["м"] = "v",
	["и"] = "b", ["т"] = "n", ["ь"] = "m", ["б"] = ",", ["ю"] = ".", ["Й"] = "Q", ["Ц"] = "W", ["У"] = "E", ["К"] = "R", ["Е"] = "T", ["Н"] = "Y", ["Г"] = "U", ["Ш"] = "I",
	["Щ"] = "O", ["З"] = "P", ["Х"] = "{", ["Ъ"] = "}", ["Ф"] = "A", ["Ы"] = "S", ["В"] = "D", ["А"] = "F", ["П"] = "G", ["Р"] = "H", ["О"] = "J", ["Л"] = "K", ["Д"] = "L",
	["Ж"] = ":", ["Э"] = "\"", ["Я"] = "Z", ["Ч"] = "X", ["С"] = "C", ["М"] = "V", ["И"] = "B", ["Т"] = "N", ["Ь"] = "M", ["Б"] = "<", ["Ю"] = ">"
}

local charsvk = {
	"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
}

local kysti = { 713, 753, 754, 755, 756, 757, 789, 647, 823, 864 }

local my_font1 = renderCreateFont('Verdana', 6, font_flag.BOLD + font_flag.SHADOW)
local my_font2 = renderCreateFont('Verdana', 8, font_flag.BOLD + font_flag.SHADOW)
local my_font3 = renderCreateFont('Verdana', 10, font_flag.BOLD + font_flag.SHADOW)

local channel_osnova = '#dgrapeevreida'
local connected = false
local lastMessage = 0

local tsrbox = '0'

local vkoinsev = '0'

local tab = imgui.ImInt(0)
local tabs = {
    fa.ICON_FA_HANDS_HELPING..u8' Хелпер',
    fa.ICON_FA_COGS..u8' Настройки',
    fa.ICON_FA_BELL..u8' Уведы ВК',
	fa.ICON_FA_CLIPBOARD_LIST..u8' Информер',
	fa.ICON_FA_FILE_ALT..u8' Логи',
    fa.ICON_FA_INFO..u8' Информация',
    fa.ICON_FA_WRENCH..u8' Обновления',
}

local tabs2 = { u8'Главная', u8'Хелпер', u8'Настройки', u8'Уведы ВК', u8'Информер', u8'Логи', u8'Информация', u8'Обновления' }
--local tabs2 = { u8'Главная', u8'Хелпер', u8'Настройки', u8'Уведы ВК', u8'Информация', u8'Обновления' }

bike = {[481] = true, [509] = true, [510] = true}
moto = {[448] = true, [461] = true, [462] = true, [463] = true, [468] = true, [471] = true, [521] = true, [522] = true, [523] = true, [581] = true, [586] = true}

local wTime = 0
local joinCount = 0

local use1 = false
local check_chest = false
local openchestvk = false

local flymode = 0  
local speed = 0.1
local radarHud = 0
local time = 0
local keyPressed = 0

local restore_text = false
local dialogs_data = {}
local dialogIncoming = 0

local active_forma = false
local active_keys = false
local active_keyson = false
local active_keys2 = false
local active_keyson2 = false
local stop_forma = false

local car_enabled = false

local npc, infnpc = {}, {}

local sw, sh = getScreenResolution()

local editKeys = 0

local keyv, server, ts
local group_id = '198154439'

local notf_sX, notf_sY = convertGameScreenCoordsToWindowScreenCoords(630, 438)
local notify = {
	messages = {},
	active = 0,
	max = 6,
	list = {
		pos = { x = notf_sX - 200, y = notf_sY },
		npos = { x = notf_sX - 200, y = notf_sY },
		size = { x = 200, y = 0 }
	}
}

if doesFileExist(jsonDir) then
    local f = io.open(jsonDir, "a+")
    cfg1 = decodeJson(f:read("*a"))
    f:close()
else
    createDirectory(getGameDirectory().."\\moonloader\\config\\MRH")
    local f = io.open(jsonDir, "w")
    f:write(encodeJson(cfg1))
    f:close()
end

if doesFileExist(jsonDir2) then
    local f = io.open(jsonDir2, "a+")
    cfg2 = decodeJson(f:read("*a"))
    f:close()
else
    createDirectory(getGameDirectory().."\\moonloader\\config\\MRH")
    local f = io.open(jsonDir2, "w")
    f:write(encodeJson(cfg2))
    f:close()
end

local function send_player_stream(id, i)
	if i then
		local bs = raknetNewBitStream()
		raknetBitStreamWriteInt16(bs, id)
		raknetBitStreamWriteInt8(bs, i[1])
		raknetBitStreamWriteInt32(bs, i[2])
		raknetBitStreamWriteFloat(bs, i[3].x)
		raknetBitStreamWriteFloat(bs, i[3].y)
		raknetBitStreamWriteFloat(bs, i[3].z)
		raknetBitStreamWriteFloat(bs, i[4])
		raknetBitStreamWriteInt32(bs, i[5])
		raknetBitStreamWriteInt8(bs, i[6])
		raknetEmulRpcReceiveBitStream(32, bs)
	end
end

local buy = {
	imgui.ImBool(false), -- 1 Клик мыши
	imgui.ImBool(false), -- 2 Видеокарта
	imgui.ImBool(false), -- 3 Стойка видеокарт
	imgui.ImBool(false), -- 4 Суперкомпьютер
	imgui.ImBool(false), -- 5 Сервер Arizona Games
	imgui.ImBool(false), -- 6 Квантовый компьютер
	imgui.ImBool(false), -- 7 Датацентр
}

local ids = {
	dialogPhone = 1000, -- ИД диалога выбора телефона
	dialogBoost = 25012, -- ИД диалога покупки переферии 

	phones = {
		{
			name = "Xiaomi Mi 8",
			menuCoin = 2119, -- ИД ТД открытия меню ВКкоин
			menuBoost = 2101, -- ИД ТД кнопки открытия меню покупки переферии (Кнопка boost)
			tdBalance = 2103, -- ИД ТД баланса
			tdClick = 2104, -- ИД ТД для клика (Синия хуевина с надписью PAY в меню коина)
		},
		{
			name = "Huawei P20 PRO",
			menuCoin = 2119,
			menuBoost = 2102,
			tdBalance = 2104,
			tdClick = 2105,
		},
		{
			name = "Google Pixel 3",
			menuCoin = 2118,
			menuBoost = 2099,
			tdBalance = 2101,
			tdClick = 2102,
		},
	}
}

local navigation = {
    current = 1,
    list = { u8"Стиль", u8"АвтоАФК", u8"Биндер", u8"Другое", u8"Загрузки", u8"Клады"}
}

local navigation2 = {
    current = 1,
    list = { u8"За сессию", u8"За день", u8"Онлайн по неделям", u8"За все время", u8"Настройки"}
}

local veh = {
    {541,-2657.100,-9.434,3.950,180},
	{411,-2653.550,-9.682,4.079,180},
    {560,-2650.070,-9.670,4.043,180},
	{451,-2646.560,-9.943,4.031,180},
	{415,-2643.010,-9.623,4.101,180},
	{559,-2639.540,-9.587,3.967,180},
	{429,-2636.080,-9.683,4.004,180},
	{506,-2632.570,-9.754,4.028,180},
	{480,-2625.590,-9.712,4.121,180},
	{463,-2685.640,-4.473,3.867,0},
	{468,-2682.060,-4.433,4.005,0},
	{471,-2678.530,-4.411,3.849,0},
	{586,-2675.150,-4.273,3.841,0},
	{581,-2685.510,-9.332,3.923,180},
	{522,-2682.040,-9.265,3.879,180},
	{461,-2678.470,-9.276,3.908,180},
	{521,-2675.070,-9.239,3.901,180},
	{502,-2653.590,-28.856,4.225,180},
	{503,-2650.040,-28.860,4.225,180},
	{494,-2657.030,-28.851,4.225,180},
	{4789,-509.013,2570.634,53.415,90},
	{667,-527.904,2617.090,53.414,89},
	{4774,-509.478,2556.152,53.414,89},
	{4779,-509.285,2560.951,53.414,89},
	{3239,-2685.544,-22.165,4.326,359.7},
	{3218,935.490,2132.586,10.839,359.9},
	{3240,-2678.593,-21.998,4.3267,359.7},
	{3248,-2675.070,-28.347,4.3267,179.8},
	{3233,-2682.058,-28.082,4.3267,179.5},
	{3232,-2685.480,-28.259,4.3267,179.8},
	{6612,-2675.037,-40.863,4.326,359.8},
	{495,974.577,2132.394,10.839,359.7},
    {475,978.254,2126.633,10.839,180},
    {3217,977.950,2145.689,10.839,180},
    {1203,971.105,2145.851,10.839,180},
    {6610,964.023,2146.150,10.839,180},
    {6607,957.102,2145.894,10.839,180},
    {3213,939.032,2114.557,10.839,359.7},
    {3251,960.497,2164.704,10.839,180},
    {3208,967.537,2165.233,10.839,180},
    {3238,974.568,2170.353,10.839,0 },
    {3235,977.999,2164.617,10.839,180},
    {3237,981.532,2170.657,10.833,0},
    {3234,984.965,2165.268,10.833,180},
	{3219,978.206,2107.953,10.839,179.7},
	{535,971.345,2127.064,10.839,179.7},
	{1202,-509.072,2606.097,53.414,89.7},
    {1203,-509.006,2611.083,53.415,89},
    {1204,-508.847,2615.876,53.415,90},
    {1205,-508.553,2625.523,53.414,89},
    {3245,-508.496,2630.429,53.414,89},
    {3247,-508.212,2635.252,53.414,90},
    {3157,-519.178,2612.425,53.415,270},
    {663,-519.546,2607.446,53.414,269},
    {4794,-508.749,2580.436,53.414,90},
    {4793,-508.903,2575.629,53.414,89},
    {4783,-508.966,2565.851,53.414,88},
    {1196,-520.447,2561.596,53.414,269},
    {1195,-520.147,2566.785,53.414,269},
	{1194,-520.078,2571.901,53.414,269},
    {965,-519.927,2577.048,53.414,269},
    {909,-519.897,2582.146,53.414,269},
    {1201,-528.607,2579.050,53.414,89},
    {1200,-528.450,2574.030,53.414,89},
    {1199,-528.752,2568.931,53.414,89},
    {1198,-528.563,2563.827,53.414,89},
    {1197,-529.119,2558.675,53.414,89},
    {3236,-527.936,2606.767,53.414,89},
    {666,-527.798,2622.337,53.414,89},
    {665,-527.440,2627.444,53.414,89},
	{3200,-500.596,-491.043,25.581,90},
    {3203,-544.971,-517.184,25.581,270},
    {3211,-555.280,-535.399,25.581,89},
    {3215,-490.083,-532.930,25.581,270},
    {3216,-600.418,-499.005,25.581,270},
	{562,984.857,2113.837,10.833,0},
	{603,981.511,2114.295,10.833,0},
    {402,978.004,2114.295,10.839,0},
    {579,974.496,2114.255,10.839,0},
    {602,971.020,2114.154,10.839,360},
    {554,967.566,2114.571,10.839,360},
    {400,963.897,2114.101,10.839,0},
    {482,960.328,2114.213,10.839,360},
    {600,956.975,2113.951,10.839,360},
    {474,956.921,2126.511,10.839,180},
    {534,960.462,2126.774,10.839,180},
    {421,964.069,2126.490,10.839,180},
    {491,967.684,2126.446,10.839,180},
    {565,974.902,2127.230,10.839,180},
    {439,981.825,2126.868,10.833,180},
    {545,985.213,2132.766,10.833,0},
    {434,978.250,2132.550,10.839,0},
    {587,971.149,2133.167,10.839,360},
    {536,964.130,2133.600,10.839,0},
    {533,960.734,2132.974,10.839,0},
    {558,957.233,2133.195,10.839,360},
	{458,981.843,2133.183,10.833,360},
	{477,967.617,2133.187,10.839,360},
	{566,985.002,2126.290,10.833,180},
}

local vehArray = {}

function CreateVehicle(id, x,y,z, rotation, col1, col2)
	if not hasModelLoaded(id) then
		requestModel(id)
		loadAllModelsNow()
	end
	local car = createCar(id, x,y,z)
		setCarHeading(car, rotation)
		changeCarColour(car, col1, col2)
	return car
end

local recarz = lua_thread.create_suspended(function() -- one launch
	wait(temp1 * 950)
	sampDisconnectWithReason(false)
	wait(50)
	sampSetGamestate(1)
end)

function onWindowMessage(msg, wparam, lparam)
	if msg == wm.WM_KEYDOWN or msg == wm.WM_SYSKEYDOWN then
		if tEditData.id > -1 then
			if wparam == key.VK_ESCAPE then
				tEditData.id = -1
				consumeWindowMessage(true, true)
			elseif wparam == key.VK_TAB then
				bIsEnterEdit.v = not bIsEnterEdit.v
				consumeWindowMessage(true, true)
			end
		end
	end
    if msg == 0x100 or msg == 0x101 then
        if wparam == key.VK_ESCAPE and igvars.main_window_state.v then
            consumeWindowMessage(true, false)
            if msg == 0x101 then
				igvars.main_window_state.v = false
			end
        end
		if wparam == key.VK_ESCAPE and igvars.new_report.v then
            consumeWindowMessage(true, false)
            if msg == 0x101 then
				sampSendDialogResponse(32, 0, _, "")
				igvars.new_report.v = false
			end
        end
    end
end

function getPlayerInfo()
	sendvknotf('\nНедоступно')
end

function getPlayerArzStats()
	if sampIsLocalPlayerSpawned() then
		sendstatsstate = true
		sampSendChat('/stats')
		local timesendrequest = os.clock()
		while os.clock() - timesendrequest <= 10 do
			wait(0)
			if sendstatsstate ~= true then
				timesendrequest = 0
			end 
		end
		sendvknotf(sendstatsstate == true and 'Ошибка! В течении 10 секунд скрипт не получил информацию!' or tostring('\n'..sendstatsstate))
		sendstatsstate = false
	else
		sendvknotf('\nПерсонаж не заспавнен')
	end
end

function check_chest1()
	lua_thread.create(function()
		check_chest = true
		sampSendClickTextdraw(65535)
		wait(500)
		sampSendChat("/invent")
	end)
end

function getNearestCoord()
    local mX, mY, mZ = getCharCoordinates(PLAYER_PED)
    local mindist = 9999
    local nearest = 0
    for i, C in ipairs(coords) do
        local sddist = getDistanceBetweenCoords3d(mX, mY, mZ, C[1], C[2], C[3])
        if sddist <= mindist then
            mindist = sddist
            nearest = i
        end
    end
    return nearest
end

function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function klad3d_new()
	while tr.isEnableklad_new do
		wait(0)
		if coords then
			for i, C in ipairs(coords) do
				local sx, sy = convert3DCoordsToScreen(C[1], C[2], C[3])
				if isPointOnScreen(C[1], C[2], C[3], 5) and i == getNearestCoord() then
					local pX, pY, pZ = getCharCoordinates(PLAYER_PED)
					local pcX, pcY = convert3DCoordsToScreen(pX, pY, pZ)
					local glist = getDistanceBetweenCoords3d(pX, pY, pZ, C[1], C[2], C[3])
					glist = ("%.0f"):format(glist)
					glist = tonumber(glist)
					local font, color = my_font2, "0xFFFF0000"
					if glist <= 14 then
						font = my_font3
						color = "0xFF00FF00"
						C[1], C[2], C[3] = nil
					elseif glist <= 200 and glist >= 15 then 
						font = my_font3
						color = "0xFF00FF00"
						if igvars.tracerklad.v then
							renderDrawLine(pcX, pcY, sx, sy, 1.0, color)
						end
					elseif glist >= 201 and glist <= 400 then 
						font = my_font2 
						color = "0xFF00FFFF" 
					elseif glist >= 401 then 
						font = my_font1 
						color = "0xFFFF0000"
					end
					renderFontDrawText(font, "Клад ["..glist.."]", sx, sy, color)
				end
			end
		end
	end
	if not tr.isEnableklad_new then
		coords = nil
	end
end

function klad3d()
	while tr.isEnableklad do
		wait(0)
		if coords then
			for i, C in ipairs(coords) do
				local sx, sy = convert3DCoordsToScreen(C[1], C[2], C[3])
				if isPointOnScreen(C[1], C[2], C[3], 5) then
					local pX, pY, pZ = getCharCoordinates(PLAYER_PED)
					local pcX, pcY = convert3DCoordsToScreen(pX, pY, pZ)
					local glist = getDistanceBetweenCoords3d(pX, pY, pZ, C[1], C[2], C[3])
					glist = ("%.0f"):format(glist)
					glist = tonumber(glist)
					local font, color = my_font2, "0xFFFF0000"
					if glist <= 14 then
						font = my_font3
						color = "0xFF00FF00"
						C[1], C[2], C[3] = nil
					elseif glist <= 200 and glist >= 15 then 
						font = my_font3
						color = "0xFF00FF00"
						if igvars.tracerklad.v then
							renderDrawLine(pcX, pcY, sx, sy, 1.0, color)
						end
					elseif glist >= 201 and glist <= 400 then 
						font = my_font2 
						color = "0xFF00FFFF" 
					elseif glist >= 401 then 
						font = my_font1 
						color = "0xFFFF0000"
					end
					renderFontDrawText(font, "Клад ["..glist.."]", sx, sy, color)
				end
			end
		end
	end
	if not tr.isEnableklad then
		coords = nil
	end
end

function narko3d()
	while tr.isEnablenarko do
		wait(0)
		if coordsnarko then
			for i=1, #coordsnarko do	
				local sx, sy = convert3DCoordsToScreen(coordsnarko[i][1], coordsnarko[i][2], coordsnarko[i][3])
				if isPointOnScreen(coordsnarko[i][1], coordsnarko[i][2], coordsnarko[i][3], 5) then
					local pX, pY, pZ = getCharCoordinates(PLAYER_PED)
					local pcX, pcY = convert3DCoordsToScreen(pX, pY, pZ)
					local glist = getDistanceBetweenCoords3d(pX, pY, pZ, coordsnarko[i][1], coordsnarko[i][2], coordsnarko[i][3])
					glist = ("%.0f"):format(glist)
					glist = tonumber(glist)
					local font, color = my_font2, "0xFFFF0000"
					if glist == 14 then
						font = my_font3
						color = "0xFF00FF00"
						coordsnarko[i][1], coordsnarko[i][2], coordsnarko[i][3] = nil
					elseif glist <= 200 and glist >= 15 then 
						font = my_font3
						color = "0xFF00FF00"
					elseif glist >= 201 and glist <= 400 then 
						font = my_font2 
						color = "0xFF00FFFF" 
					elseif glist >= 401 then 
						font = my_font1 
						color = "0xFFFF0000"
					end
					renderFontDrawText(font, "Нарко ["..glist.."]", sx, sy, color)
				end
			end
		end
	end
	if not tr.isEnablenarko then
		coordsnarko = nil
	end
end

function separator(text)
	if text:find("$") then
	    for S in string.gmatch(text, "%$%d+") do
	    	local replace = comma_value(S)
	    	text = string.gsub(text, S, replace)
	    end
	    for S in string.gmatch(text, "%d+%$") do
	    	S = string.sub(S, 0, #S-1)
	    	local replace = comma_value(S)
	    	text = string.gsub(text, S, replace)
	    end
	end
	return text
end

local mMin = 0
local sSec = 0
local Activated = false

function watherandtime()
	while true do 
		if igvars.sett.v ~= -1 then writeMemory(0xB70153, 1, igvars.sett.v, true) end
		if igvars.setw.v ~= -1 then writeMemory(0xC81320, 1, igvars.setw.v, true) end
		if igvars.timedraw.v then renderFontDrawText(customFont, os.date(igvars.colort.v.."%H:%M:%S"), igvars.timeX.v, igvars.timeY.v, 0xFFFFFFFF) end
		if Activated then renderFontDrawText(customFont, string.format("%02d:%02d", mMin, sSec), sw/2, sh/1.1, 0xFFFFFFFF) end
		wait(0)
	end
end

function timer_chest()
	while true do 
		if Activated then 
			if sSec == 0 then 
				mMin = mMin - 1
				sSec = 60
			end
			wait(1000)
			sSec = sSec-1
			if mMin == 0 and sSec == 0 then 
				Activated = false
			end
		end
		wait(0)
	end
end

local iniFont = 'Courier New'
function fontUpdate(timefont)
	if timefont == 0 then iniFont = 'Courier New' end
	if timefont == 1 then iniFont = 'Arial' end
	if timefont == 2 then iniFont = 'Arial Black' end
	if timefont == 3 then iniFont = 'Franklin Gothic Medium' end
	if timefont == 4 then iniFont = 'Impact' end
	customFont = renderCreateFont(iniFont, igvars.timeHeight.v, igvars.timeVar.v)
end

function imguiproc()
	while true do
		if ismenuenabled then
			wait(250)
			ismenuenabled = false
		end
		wait(0)
	end
end

local si_thinkbool = false
function waitping()
	while true do
		if connected and not si_thinkbool then
			wait(1000)
			si_think = xpcall(sithink, myerrorhandler)
			if not si_think then
				si_thinkbool = true
			end
		else
			wait(0)
		end
	end
end

function checkafk()
	local akfc = 0
	while true do
			x2, y2, z2 = getCharCoordinates(PLAYER_PED)
			wait(120000)
			if x1 == x2 then
				if akfc > 5 and getDistanceBetweenCoords3d(x1, y1, z1, -2160.3530273438, -2127.5776367188, 1501.0964355469) < 20 then
					if not igvars.autohawk.v then
						sampAddChatMessage('[MRH/AutoHawka] {ffffff}Автоеда включена', ini.config.clrtext)
						igvars.autohawk.v = true
						--akfc = 0
					end	
				end
				if akfc > 6 then
					akfc = 0
					if not si_think and not tr.openStartChest.v then
						si_thinkbool = true
						sampAddChatMessage('[MRH] Произошла ошибка. Скрипт будет автоматически перезагружен через 20 секунд.', -1)
						wait(20000)
						print('Обновил')
						tr.reloadR = true
						thisScript():reload()
					end
				end
				akfc = akfc + 1
			else 
				akfc = 0
			end
		wait(0)
	end
end

function shiftn1()
	while true do
		if igvars.max_speed.v then
			if isCharOnAnyBike(playerPed) and isKeyCheckAvailable() and isKeyDown(0xA0) then	-- onBike&onMoto SpeedUP [[LSHIFT]] --
				if bike[getCarModel(storeCarCharIsInNoSave(playerPed))] then
					setGameKeyState(16, 255)
					wait(10)
					setGameKeyState(16, 0)
				elseif moto[getCarModel(storeCarCharIsInNoSave(playerPed))] then
					setGameKeyState(1, -128)
					wait(10)
					setGameKeyState(1, 0)
				end
			end
		end
		if igvars.max_speedped.v then
			if isCharOnFoot(playerPed) and isKeyDown(0x31) and isKeyCheckAvailable() then -- onFoot&inWater SpeedUP [[1]] --
				setGameKeyState(16, 256)
				wait(10)
				setGameKeyState(16, 0)
			elseif isCharInWater(playerPed) and isKeyDown(0x31) and isKeyCheckAvailable() then
				setGameKeyState(16, 256)
				wait(10)
				setGameKeyState(16, 0)
			end
		end
		wait(0)
	end
end

function sithink()
	si:think()
end

local tempField = ''
function sicon()
	si:connect("ircluxe.ru")
    si:hook("OnChat", onIRCMessage)
    si:hook("OnDisconnect", onIRCDisconnect)
    connected = true
end
 
function myerrorhandler(err)
	print( "ERROR:", err )
end

function reqdw()
	if not doesFileExist(getWorkingDirectory()..'\\resource\\fonts\\fa-solid-900.ttf') or
	not doesFileExist(getWorkingDirectory()..'\\lib\\fAwesome5.lua') or
	not doesFileExist(getWorkingDirectory()..'\\lib\\rkeys.lua') or
	not doesFileExist(getWorkingDirectory()..'\\lib\\luaircv2.lua') or
	not doesFileExist(getWorkingDirectory()..'\\lib\\rkeys1.lua') or
	not doesFileExist(getWorkingDirectory()..'\\lib\\luaircv2_1.lua') or
	not doesFileExist(getWorkingDirectory()..'\\resource\\img\\mshk_fred.png') or
	not doesFileExist(getWorkingDirectory()..'\\resource\\img\\teminator.png') then

		sampAddChatMessage('[MRH] {ffffff}Началась подгрузка необходимых библиотек...', ini.config.clrtext)
		if not doesFileExist(getWorkingDirectory()..'\\resource\\fonts\\fa-solid-900.ttf') then
			createDirectory(getWorkingDirectory()..'\\resource\\fonts')
			--downloadFile('fa-solid-900', getWorkingDirectory()..'\\resource\\fonts\\fa-solid-900.ttf', 'https://github.com/sawyx/mrh/raw/main/libsnres')
			download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/libsnres/fa-solid-900.ttf', getWorkingDirectory()..'\\resource\\fonts\\fa-solid-900.ttf', download_handler)
			while not doesFileExist(getWorkingDirectory()..'\\resource\\fonts\\fa-solid-900.ttf') do wait(0) end
		end
		if not doesFileExist(getWorkingDirectory()..'\\lib\\luaircv2.lua') then
			download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/libsnres/luaircv2.lua', getWorkingDirectory()..'\\lib\\luaircv2.lua', download_handler)
			while not doesFileExist(getWorkingDirectory()..'\\lib\\luaircv2.lua') do wait(0) end
		end
		if not doesFileExist(getWorkingDirectory()..'\\lib\\fAwesome5.lua') then
			download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/libsnres/fAwesome5.lua', getWorkingDirectory()..'\\lib\\fAwesome5.lua', download_handler)
			while not doesFileExist(getWorkingDirectory()..'\\lib\\fAwesome5.lua') do wait(0) end
		end
		if not doesFileExist(getWorkingDirectory()..'\\lib\\rkeys.lua') then
			download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/libsnres/rkeys.lua', getWorkingDirectory()..'\\lib\\rkeys.lua', download_handler)
			while not doesFileExist(getWorkingDirectory()..'\\lib\\rkeys.lua') do wait(0) end
		end
		if not doesFileExist(getWorkingDirectory()..'\\resource\\img\\mshk_fred.png') then
			createDirectory(getWorkingDirectory()..'\\resource\\img')
			download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/libsnres/mshk_fred.png', getWorkingDirectory()..'\\resource\\img\\mshk_fred.png', download_handler)
			while not doesFileExist(getWorkingDirectory()..'\\resource\\img\\mshk_fred.png') do wait(0) end
		end
		if not doesFileExist(getWorkingDirectory()..'\\resource\\img\\teminator.png') then
			createDirectory(getWorkingDirectory()..'\\resource\\img')
			download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/libsnres/teminator.png', getWorkingDirectory()..'\\resource\\img\\teminator.png', download_handler)
			while not doesFileExist(getWorkingDirectory()..'\\resource\\img\\teminator.png') do wait(0) end
		end
		if doesFileExist(getWorkingDirectory()..'\\lib\\rkeys.lua') or not doesFileExist(getWorkingDirectory()..'\\lib\\rkeys1.lua') then
			os.rename(getWorkingDirectory()..'\\lib\\rkeys.lua', getWorkingDirectory()..'\\lib\\rkeys1.lua')
			rkeysdownload = true
			download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main//libsnres/new/rkeys.lua', getWorkingDirectory()..'\\lib\\rkeys.lua', download_handler)
			while not doesFileExist(getWorkingDirectory()..'\\lib\\rkeys.lua') do wait(0) end
		end
		if doesFileExist(getWorkingDirectory()..'\\lib\\luaircv2.lua') or not doesFileExist(getWorkingDirectory()..'\\lib\\luaircv2_1.lua') then
			os.rename(getWorkingDirectory()..'\\lib\\luaircv2.lua', getWorkingDirectory()..'\\lib\\luaircv2_1.lua')

			download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main//libsnres/new/luaircv2.lua', getWorkingDirectory()..'\\lib\\luaircv2.lua', download_handler)
			while not doesFileExist(getWorkingDirectory()..'\\lib\\luaircv2.lua') do wait(0) end
		end
		sampAddChatMessage('[MRH] {ffffff}Подгрузка необходимых библиотек закончена. Перезагрузите скрипт!', ini.config.clrtext)
	end
end

function setMarker(type, x, y, z, radius)
    deleteCheckpoint(marker)
    removeBlip(checkpoint)
    checkpoint = addBlipForCoord(x, y, z)
    marker = createCheckpoint(type, x, y, z, 1, 1, 1, radius)
    lua_thread.create(function()
    repeat
        wait(0)
        local x1, y1, z1 = getCharCoordinates(PLAYER_PED)
        until getDistanceBetweenCoords3d(x, y, z, x1, y1, z1) < radius or not doesBlipExist(checkpoint)
        deleteCheckpoint(marker)
        removeBlip(checkpoint)
    end)
end

mcx = 0x0087FF
local sX, sY = getScreenResolution()
local to = imgui.ImBool(cfg.statTimers.state)
local nowTime = os.date("%H:%M:%S", os.time())
local settings = imgui.ImBool(false)
local myOnline = imgui.ImBool(false)
local pos = false
local restart = false
local recon = false

local sesOnline = imgui.ImInt(0)
local sesAfk = imgui.ImInt(0)
local sesFull = imgui.ImInt(0)
local dayFull = imgui.ImInt(cfg.onDay.full)
local weekFull = imgui.ImInt(cfg.onWeek.full)
local sRound = imgui.ImFloat(cfg.style.round)

local argbW = cfg.style.colorW
local argbT = cfg.style.colorT
local colorW = imgui.ImFloat4(imgui.ImColor(argbW):GetFloat4())
local colorT = imgui.ImFloat4(imgui.ImColor(argbT):GetFloat4())

local posX, posY = cfg.pos.x, cfg.pos.y
local Radio = {
	['clock'] = cfg.statTimers.clock,
	['sesOnline'] = cfg.statTimers.sesOnline,
	['sesAfk'] = cfg.statTimers.sesAfk,
	['sesFull'] = cfg.statTimers.sesFull,
	['dayOnline'] = cfg.statTimers.dayOnline,
	['dayAfk'] = cfg.statTimers.dayAfk,
	['dayFull'] = cfg.statTimers.dayFull,
	['weekOnline'] = cfg.statTimers.weekOnline,
	['weekAfk'] = cfg.statTimers.weekAfk,
	['weekFull'] = cfg.statTimers.weekFull
}

local tWeekdays = {
    [0] = 'Воскресенье',
    [1] = 'Понедельник', 
    [2] = 'Вторник', 
    [3] = 'Среда', 
    [4] = 'Четверг', 
    [5] = 'Пятница', 
    [6] = 'Суббота'
}

function main() -- body
	while not isSampAvailable() do wait(0) end

	result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	nick_player = sampGetPlayerNickname(id)

	asyncHttpRequest('GET', 'https://raw.githubusercontent.com/sawyx/mrh/main/blacklist.json', {headers={["user-agent"] = "Mozilla/5.0"}},
	function (result)
		if result then
			local function res()
				for n in result.text:gmatch('[^\r\n]+') do -- получаем список ников из ссылки
					if nick_player:find(n) then return true end  -- если находит ник то все гуд и скрипт работает дальше
				end
				return false
			end
			if res() then
				sampAddChatMessage('[MRH] {ffffff}Ты в черном списке скрипта дурачочек', ini.config.clrtext)
				error('Пока')
			end
		end
	end)

	if resirc then
		nick_id = nick_player..'['..id..']'
		si = irc.new{nick = nick_id}
	end

    wait(100)
	si_status = xpcall(sicon, myerrorhandler)
	
	if sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) == 'Down_Cursed' then
		print('Вы вошли как разработчик!')
		devmode = true
	end

	sampRegisterChatCommand("1s", function()
		igvars.tsr_informer.v = not igvars.tsr_informer.v
	end)

	if brk then
		for k, v in pairs(tBindList) do
			rkeys.registerHotKey(v.v, true, onHotKey)
		end
	end

	if cfg.onDay.today ~= os.date("%a") then 
		cfg.onDay.today = os.date("%a")
		cfg.onDay.online = 0
	   	cfg.onDay.full = 0
	   	cfg.onDay.afk = 0
	   	dayFull.v = 0
	   	inicfg.save(cfg, d_ini)
   	end

   	if cfg.onWeek.week ~= number_week() then
	   	cfg.onWeek.week = number_week()
		cfg.onWeek.online = 0
	   	cfg.onWeek.full = 0
	   	cfg.onWeek.afk = 0
	   	weekFull.v = 0
	   	for _, v in pairs(cfg.myWeekOnline) do v = 0 end            
	   	inicfg.save(cfg, d_ini)
   	end

   	sampRegisterChatCommand('toset', function()
	   	settings.v = not settings.v
   	end)

   	sampRegisterChatCommand('online', function()
	   	myOnline.v = not myOnline.v
   	end)

   	lua_thread.create(time)
   	lua_thread.create(autoSave)

	sampRegisterChatCommand('pcar', function()
        car_enabled = not car_enabled
        sampAddChatMessage(car_enabled and '[MRH] {ffffff}Расположение машин включено' or '[MRH] {ffffff}Расположение машин выключено', ini.config.clrtext)
        if car_enabled then
			for i = 1, #veh do
                vehArray[#vehArray + 1] = CreateVehicle(veh[i][1], veh[i][2],veh[i][3],veh[i][4], veh[i][5], 1, 1)
            end
        else
			for i = 1, #vehArray do
                deleteCar(vehArray[i])
            end
        end
    end)

	sampRegisterChatCommand("ifix", invfix)
	sampRegisterChatCommand('cf', chatfam)
	sampRegisterChatCommand('crep', chatrep)
	sampRegisterChatCommand('cpos', chatpos)
	sampRegisterChatCommand('rep', cmd_rep)
	sampRegisterChatCommand('mshowmc', showm)
	fontUpdate(igvars.timeFont.v)
	a_afk()
	irun()
	getAnswer(false)
	lua_thread.create(watherandtime)
	lua_thread.create(timer_chest)
	lua_thread.create(inputChat)
	lua_thread.create(imguiproc)
	lua_thread.create(waitping)
	lua_thread.create(vkoinfunc)
	lua_thread.create(reqdw)
	lua_thread.create(checkafk)
	lua_thread.create(shiftn1)
	if igvars.vknotf.v then
		longpollGetKey()
		while not keyv do wait(1) end
		loop_async_http_request(server .. '?act=a_check&key=' .. keyv .. '&ts=' .. ts .. '&wait=25', '')
	end
	imgui.Process = true
	while true do
		wait(0)
		if connected and irctable.__isConnected and d_joined then
			wait(25)
			si:join('#dgrapeevreida')
			d_joined = nil
		end
		x1, y1, z1 = getCharCoordinates(PLAYER_PED)
		if igvars.main_window_state.v or igvars.window_calc.v or igvars.tsr_informer.v or igvars.window_vkoin.v or igvars.new_report.v or to.v or settings.v or myOnline.v then 
			imgui.ShowCursor = igvars.main_window_state.v or igvars.new_report.v or settings.v or myOnline.v
			imgui.Process = true
		elseif #notify.messages > 0 then
			imgui.ShowCursor = false
			--imgui.SetMouseCursor(-1)
			imgui.Process = true
		else
			imgui.Process = false
		end
		if igvars.home_l.v then
			if isKeyDown(0x12) and (Search3Dtext(x1, y1, z1, 1.5, "Grape") or Search3Dtext(x1, y1, z1, 1.5, "Cursed")) and not Search3Dtext(x1, y1, z1, 1.5, "_") then
				homejoin()
				wait(250)
			end
		end
		if active_keys and wasKeyPressed(0x39) and isKeyDown(0x12) then
			active_keyson = true
			active_keys = false
		end
		if active_keys2 and wasKeyPressed(0x38) and isKeyDown(0x12) then
			active_keyson2 = true
			active_keys2 = false
		end
		if dialogIncoming ~= 0 and dialogs_data[dialogIncoming] and igvars.savedialog.v then
			local data = dialogs_data[dialogIncoming]
			if data[1] and not restore_text then
				sampSetCurrentDialogListItem(data[1])
			end
			if data[2] then
				sampSetCurrentDialogEditboxText(data[2])
			end
			dialogIncoming = 0
		end
		if igvars.calc.v then
			local text = sampGetChatInputText()
			if text:find('%d+') and text:find('[-+/*^%%]') and not text:find('%a+') and text ~= nil then
				ok, number = pcall(load('return '..text))
				if ok then
					number = comma_value(tostring(number))
					resultcal = 'Результат: '..number
					igvars.window_calc.v = true
				end
			end
			if text == '' then
				igvars.window_calc.v = false
			end
		end
		if isKeyDown(VK_F9) and isKeyCheckAvailable() and not ismenuenabled then
			igvars.main_window_state.v = not igvars.main_window_state.v
			ismenuenabled = true
		end
		if tr.reloadR then
			--reloadR = false
			inicfg.save(cfg, d_ini)
		end
		if ini.config.rec_restart then
			if ini.config.time_restart == os.date('%H:%M:%S') then
				sampDisconnectWithReason(false)
				wait(2500)
				sampSetGamestate(1)
			end
		end
		local chatstr = sampGetChatString(99)
		if chatstr == "Wrong server password." then
			sampDisconnectWithReason(false)
			wait(2500)
			sampSetGamestate(1)
		elseif chatstr == "You are banned from this server." then
			sampDisconnectWithReason(false)
			wait(2500)
			sampSetGamestate(1)
		end
		if igvars.olock_c.v and not sampIsChatInputActive() and testCheat("ol") then
			sampSendChat("/olock")
		end
		if igvars.jlock_car.v and not sampIsChatInputActive() and testCheat("jl") then
			sampSendChat("/jlock")
		end
		if igvars.lock_c.v and not sampIsChatInputActive() and testCheat("l") then
			sampSendChat("/lock")
		end
		if igvars.key_c.v and not sampIsChatInputActive() and testCheat("k") then
			sampSendChat("/key")
		end
		if igvars.phone.v and not sampIsChatInputActive() and testCheat("p") then
			sampSendChat("/phone")
		end
		if igvars.home_l.v and not sampIsChatInputActive() and testCheat("hj") then
			homejoin()
		end
		if igvars.chack.v then
			if isKeyDown(VK_C) and isKeyDown(VK_1) then
				if flymode == 0 then
					displayRadar(false)
					displayHud(false)	    
					posX, posY, posZ = getCharCoordinates(playerPed)
					angZ = getCharHeading(playerPed)
					angZ = angZ * -1.0
					setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
					angY = 0.0
					lockPlayerControl(true)
					flymode = 1
				end
			end
			if flymode == 1 and not sampIsChatInputActive() and not isSampfuncsConsoleActive() then
				offMouX, offMouY = getPcMouseMovement()  
				
				offMouX = offMouX / 7.0
				offMouY = offMouY / 7.0
				angZ = angZ + offMouX
				angY = angY + offMouY

				if angZ > 360.0 then angZ = angZ - 360.0 end
				if angZ < 0.0 then angZ = angZ + 360.0 end

				if angY > 89.0 then angY = 89.0 end
				if angY < -89.0 then angY = -89.0 end   

				radZ = math.rad(angZ) 
				radY = math.rad(angY)             
				sinZ = math.sin(radZ)
				cosZ = math.cos(radZ)      
				sinY = math.sin(radY)
				cosY = math.cos(radY)       
				sinZ = sinZ * cosY      
				cosZ = cosZ * cosY 
				sinZ = sinZ * 1.0      
				cosZ = cosZ * 1.0     
				sinY = sinY * 1.0        
				poiX = posX
				poiY = posY
				poiZ = posZ      
				poiX = poiX + sinZ 
				poiY = poiY + cosZ 
				poiZ = poiZ + sinY      
				pointCameraAtPoint(poiX, poiY, poiZ, 2)

				curZ = angZ + 180.0
				curY = angY * -1.0      
				radZ = math.rad(curZ) 
				radY = math.rad(curY)                   
				sinZ = math.sin(radZ)
				cosZ = math.cos(radZ)      
				sinY = math.sin(radY)
				cosY = math.cos(radY)       
				sinZ = sinZ * cosY      
				cosZ = cosZ * cosY 
				sinZ = sinZ * 10.0     
				cosZ = cosZ * 10.0       
				sinY = sinY * 10.0                       
				posPlX = posX + sinZ 
				posPlY = posY + cosZ 
				posPlZ = posZ + sinY              
				angPlZ = angZ * -1.0

				radZ = math.rad(angZ) 
				radY = math.rad(angY)             
				sinZ = math.sin(radZ)
				cosZ = math.cos(radZ)      
				sinY = math.sin(radY)
				cosY = math.cos(radY)       
				sinZ = sinZ * cosY      
				cosZ = cosZ * cosY 
				sinZ = sinZ * 1.0      
				cosZ = cosZ * 1.0     
				sinY = sinY * 1.0        
				poiX = posX
				poiY = posY
				poiZ = posZ      
				poiX = poiX + sinZ 
				poiY = poiY + cosZ 
				poiZ = poiZ + sinY      
				pointCameraAtPoint(poiX, poiY, poiZ, 2)

				if isKeyDown(VK_W) then      
					radZ = math.rad(angZ) 
					radY = math.rad(angY)                   
					sinZ = math.sin(radZ)
					cosZ = math.cos(radZ)      
					sinY = math.sin(radY)
					cosY = math.cos(radY)       
					sinZ = sinZ * cosY      
					cosZ = cosZ * cosY 
					sinZ = sinZ * speed      
					cosZ = cosZ * speed       
					sinY = sinY * speed  
					posX = posX + sinZ 
					posY = posY + cosZ 
					posZ = posZ + sinY      
					setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)      
				end 

				radZ = math.rad(angZ) 
				radY = math.rad(angY)             
				sinZ = math.sin(radZ)
				cosZ = math.cos(radZ)      
				sinY = math.sin(radY)
				cosY = math.cos(radY)       
				sinZ = sinZ * cosY      
				cosZ = cosZ * cosY 
				sinZ = sinZ * 1.0      
				cosZ = cosZ * 1.0     
				sinY = sinY * 1.0         
				poiX = posX
				poiY = posY
				poiZ = posZ      
				poiX = poiX + sinZ 
				poiY = poiY + cosZ 
				poiZ = poiZ + sinY      
				pointCameraAtPoint(poiX, poiY, poiZ, 2)

				if isKeyDown(VK_S) then  
					curZ = angZ + 180.0
					curY = angY * -1.0      
					radZ = math.rad(curZ) 
					radY = math.rad(curY)                   
					sinZ = math.sin(radZ)
					cosZ = math.cos(radZ)      
					sinY = math.sin(radY)
					cosY = math.cos(radY)       
					sinZ = sinZ * cosY      
					cosZ = cosZ * cosY 
					sinZ = sinZ * speed      
					cosZ = cosZ * speed       
					sinY = sinY * speed                       
					posX = posX + sinZ 
					posY = posY + cosZ 
					posZ = posZ + sinY      
					setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
				end 

				radZ = math.rad(angZ) 
				radY = math.rad(angY)             
				sinZ = math.sin(radZ)
				cosZ = math.cos(radZ)      
				sinY = math.sin(radY)
				cosY = math.cos(radY)       
				sinZ = sinZ * cosY      
				cosZ = cosZ * cosY 
				sinZ = sinZ * 1.0      
				cosZ = cosZ * 1.0     
				sinY = sinY * 1.0        
				poiX = posX
				poiY = posY
				poiZ = posZ      
				poiX = poiX + sinZ 
				poiY = poiY + cosZ 
				poiZ = poiZ + sinY      
				pointCameraAtPoint(poiX, poiY, poiZ, 2)
				
				if isKeyDown(VK_A) then  
					curZ = angZ - 90.0
					radZ = math.rad(curZ)
					radY = math.rad(angY)
					sinZ = math.sin(radZ)
					cosZ = math.cos(radZ)
					sinZ = sinZ * speed
					cosZ = cosZ * speed
					posX = posX + sinZ
					posY = posY + cosZ
					setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
				end 

				radZ = math.rad(angZ) 
				radY = math.rad(angY)             
				sinZ = math.sin(radZ)
				cosZ = math.cos(radZ)      
				sinY = math.sin(radY)
				cosY = math.cos(radY)       
				sinZ = sinZ * cosY      
				cosZ = cosZ * cosY 
				sinZ = sinZ * 1.0      
				cosZ = cosZ * 1.0     
				sinY = sinY * 1.0        
				poiX = posX
				poiY = posY
				poiZ = posZ      
				poiX = poiX + sinZ 
				poiY = poiY + cosZ 
				poiZ = poiZ + sinY
				pointCameraAtPoint(poiX, poiY, poiZ, 2)       

				if isKeyDown(VK_D) then  
					curZ = angZ + 90.0
					radZ = math.rad(curZ)
					radY = math.rad(angY)
					sinZ = math.sin(radZ)
					cosZ = math.cos(radZ)       
					sinZ = sinZ * speed
					cosZ = cosZ * speed
					posX = posX + sinZ
					posY = posY + cosZ      
					setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
				end 

				radZ = math.rad(angZ) 
				radY = math.rad(angY)             
				sinZ = math.sin(radZ)
				cosZ = math.cos(radZ)      
				sinY = math.sin(radY)
				cosY = math.cos(radY)       
				sinZ = sinZ * cosY      
				cosZ = cosZ * cosY 
				sinZ = sinZ * 1.0      
				cosZ = cosZ * 1.0     
				sinY = sinY * 1.0        
				poiX = posX
				poiY = posY
				poiZ = posZ      
				poiX = poiX + sinZ 
				poiY = poiY + cosZ 
				poiZ = poiZ + sinY      
				pointCameraAtPoint(poiX, poiY, poiZ, 2)   

				if isKeyDown(VK_SPACE) then  
					posZ = posZ + speed
					setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
				end 

				radZ = math.rad(angZ) 
				radY = math.rad(angY)             
				sinZ = math.sin(radZ)
				cosZ = math.cos(radZ)      
				sinY = math.sin(radY)
				cosY = math.cos(radY)       
				sinZ = sinZ * cosY      
				cosZ = cosZ * cosY 
				sinZ = sinZ * 1.0      
				cosZ = cosZ * 1.0     
				sinY = sinY * 1.0       
				poiX = posX
				poiY = posY
				poiZ = posZ      
				poiX = poiX + sinZ 
				poiY = poiY + cosZ 
				poiZ = poiZ + sinY      
				pointCameraAtPoint(poiX, poiY, poiZ, 2) 

				if isKeyDown(VK_SHIFT) then  
					posZ = posZ - speed
					setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
				end 

				radZ = math.rad(angZ) 
				radY = math.rad(angY)             
				sinZ = math.sin(radZ)
				cosZ = math.cos(radZ)      
				sinY = math.sin(radY)
				cosY = math.cos(radY)       
				sinZ = sinZ * cosY      
				cosZ = cosZ * cosY 
				sinZ = sinZ * 1.0      
				cosZ = cosZ * 1.0     
				sinY = sinY * 1.0       
				poiX = posX
				poiY = posY
				poiZ = posZ      
				poiX = poiX + sinZ 
				poiY = poiY + cosZ 
				poiZ = poiZ + sinY      
				pointCameraAtPoint(poiX, poiY, poiZ, 2) 

				if keyPressed == 0 and isKeyDown(VK_F10) then
					keyPressed = 1
					if radarHud == 0 then
						displayRadar(true)
						displayHud(true)
						radarHud = 1
					else
						displayRadar(false)
						displayHud(false)
						radarHud = 0
					end
				end
				if wasKeyReleased(VK_F10) and keyPressed == 1 then keyPressed = 0 end
				if isKeyDown(187) then 
					speed = speed + 0.01
					printStringNow(speed, 1000)
				end 			
				if isKeyDown(189) then 
					speed = speed - 0.01 
					if speed < 0.01 then speed = 0.01 end
					printStringNow(speed, 1000)
				end   
				if isKeyDown(VK_C) and isKeyDown(VK_2) then
					displayRadar(true)
					displayHud(true)
					radarHud = 0	    
					angPlZ = angZ * -1.0
					lockPlayerControl(false)
					restoreCameraJumpcut()
					setCameraBehindPlayer()
					flymode = 0     
				end
			end
		end
	end
end

function number_week() -- получение номера недели в году
    local current_time = os.date'*t'
    local start_year = os.time{ year = current_time.year, day = 1, month = 1 }
    local week_day = ( os.date('%w', start_year) - 1 ) % 7
    return math.ceil((current_time.yday + week_day) / 7)
end

function getStrDate(unixTime)
    local tMonths = {'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'}
    local day = tonumber(os.date('%d', unixTime))
    local month = tMonths[tonumber(os.date('%m', unixTime))]
    local weekday = tWeekdays[tonumber(os.date('%w', unixTime))]
    return string.format('%s, %s %s', weekday, day, month)
end

function get_clock(time)
    local timezone_offset = 86400 - os.date('%H', 0) * 3600
    if tonumber(time) >= 86400 then onDay = true else onDay = false end
    return os.date((onDay and math.floor(time / 86400)..'д ' or '')..'%H:%M:%S', time + timezone_offset)
end

function asyncHttpRequest(method, url, args, resolve, reject)
	local request_thread = effil.thread(function (method, url, args)
	   local requests = require 'requests'
	   local result, response = pcall(requests.request, method, url, args)
	   if result then
		  response.json, response.xml = nil, nil
		  return true, response
	   else
		  return false, response
	   end
	end)(method, url, args)
	-- Если запрос без функций обработки ответа и ошибок.
	if not resolve then resolve = function() end end
	if not reject then reject = function() end end
	-- Проверка выполнения потока
	lua_thread.create(function()
	   local runner = request_thread
	   while true do
		  local status, err = runner:status()
		  if not err then
			 if status == 'completed' then
				local result, response = runner:get()
				if result then
				   resolve(response)
				else
				   reject(response)
				end
				return
			 elseif status == 'canceled' then
				return reject(status)
			 end
		  else
			 return reject(err)
		  end
		  wait(0)
	   end
	end)
end

function get_coords(backup)
	if not backup then
		asyncHttpRequest('GET', 'https://arzmap.fun/developer.php?coord&nofull', {headers = {["user-agent"] = "Mozilla/5.0"}},
		function (result)
			if result then
				local ck_result = decodeJson(u8:decode(result.text))
				if ck_result then
					if type(ck_result) == 'table' then
						coords = ck_result
						addNotify('Координаты кладов загруженны\nВ системе '.. #coords.. ' точек', 5)
					end
				else
					addNotify('Не удалось загрузить координаты\nЗагрузить резервные точки - /rklad', 5)
					igvars.isEnableklad.v = false
					igvars.isEnableklad_new.v = false
				end
			end
		end)
	else
		asyncHttpRequest('GET', 'https://pastebin.com/raw/pS15kGLa', {headers = {["user-agent"] = "Mozilla/5.0"}},
		function (result)
			if result then
				local ck_result = decodeJson(u8:decode(result.text))
				if ck_result then
					if type(ck_result) == 'table' then
						coords = ck_result
						addNotify('Координаты кладов загруженны\nВ системе '.. #coords.. ' точек', 5)
					end
				end
			end
		end)
	end

        --[[local coordkald_responce = requests.get('http://arzmap.fun/developer.php', {params = {['coord'] = 'true', ['nofull'] = 'true'}, headers = {['user-agent'] = 'Mozilla/5.0'}})
        if coordkald_responce.status_code == 200 then
            local ck_result = decodeJson(coordkald_responce.text)
            if type(ck_result) == 'table' then
                coords = ck_result
				addNotify('Координаты кладов загруженны\nВ системе '.. #coords.. ' точек', 5)
			end
		else
			addNotify('Не удалось загрузить координаты\nПопробуйте позже', 5)
		end--]]
end

function get_coords_narko() 
		asyncHttpRequest('GET', 'https://pastebin.com/raw/ntcKtNSG', {headers = {["user-agent"] = "Mozilla/5.0"}},
		function (result)
			if result then
				local cn_result = decodeJson(u8:decode(result.text))
				if cn_result then
					if type(cn_result) == 'table' then
						coordsnarko = cn_result
						addNotify('Координаты закладок загруженны\nВ системе '.. #coordsnarko.. ' точек', 5)
					end
				else
					addNotify('Не удалось загрузить координаты\nПопробуйте позже', 5)
				end
			end
		end)

        --[[local coord_narko_responce = requests.get('https://pastebin.com/raw/ntcKtNSG', {headers = {['user-agent'] = 'Mozilla/5.0'}})
        if coord_narko_responce.status_code == 200 then
            local cn_result = decodeJson(coord_narko_responce.text)
            if type(cn_result) == 'table' then
                coordsnarko = cn_result
				addNotify('Координаты закладок загруженны\nВ системе '.. #coordsnarko.. ' точек', 5)
			end
		else 
			addNotify('Не удалось загрузить координаты\nПопробуйте позже', 5)
		end--]]
end

function getAnswer(backup)
	if not backup then
		asyncHttpRequest('GET', 'https://arzmap.fun/developer.php?answer', {headers={["user-agent"] = "Mozilla/5.0"}}, -- https://pastebin.com/raw/zFHqvFKL
		function (result)
			if result then
				local ak_result = decodeJson(u8:decode(result.text))
				if ak_result then
					if type(ak_result) == 'table' then
						answ_klad = ak_result
						addNotify('Ответы на клады загруженны\nВ системе '.. #answ_klad.. ' ответа', 5)
					end
				else
					addNotify('Не удалось загрузить ответы на клады\nПопробуйте позже', 5)
				end
			end
		end)
	end

		--[[local ans_responce = requests.get("http://arzmap.fun/developer.php?answer", {headers={["user-agent"] = "Mozilla/5.0"}})
		if ans_responce.status_code == 200 then
			local ak_result = decodeJson(u8:decode(ans_responce.text))
			if type(ak_result) == 'table' then
				answ_klad = ak_result
				addNotify('Ответы на клады загруженны\nВ системе '.. #answ_klad.. ' ответа', 5)
			end
		else 
			addNotify('Не удалось загрузить ответы на клады\nПопробуйте позже', 5)
		end--]]
end

function showm(msg)
	if msg == "" then
		msg = '6'
	end
	if msg == string.match(msg, '%d+') and tonumber(msg) >= 1 and tonumber(msg) <= 29 then
	mc = string.format([[
{FFFFFF}Имя: %s

Мед. Карта [Полностью здоровый(ая)]

Срок действия: %s дня(ей)

{CEAD2A}Наркозависимость: 0{FFFFFF}

{FF4646}Вакцина от коронавируса:
 Ни разу не делалась
]], nick_player, msg)
	sampSendChat('/time')
	sampAddChatMessage(string.format('%s показывает свою мед. карту %s', nick_player, nick_player), 0xc2a2da)
	sampAddChatMessage(string.format('Вы успешно показали свою мед. карту игроку {FFFFFF}%s', nick_player), 0x42b02c)
	sampShowDialog(6405, "Мед. карта", mc, "Ок", _, DIALOG_STYLE_MSGBOX)
	end
end

function rpNick(id)
	local nick = sampGetPlayerNickname(id)
	if nick:match('_') then return nick:gsub('_', ' ') end
	return nick
end

function nonRpNick(id)
	local nick = sampGetPlayerNickname(id)
	return nick
end

function taginfo()
	if imgui.BeginPopupModal(u8("Локальные Теги"), _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize) then
		imgui.CenterTextColoredRGB('Нажми на нужный тег, что бы скопировать его') 
		imgui.Separator()
		if imgui.Button('{select_id}', imgui.ImVec2(120, 25)) then setClipboardText('{select_id}'); sampAddChatMessage('Тег скопирован!', -1) end
		imgui.SameLine(); imgui.TextColoredRGB('Получает Ид игрока с которым взаимодействуете')
		if imgui.Button('{select_name}', imgui.ImVec2(120, 25)) then setClipboardText('{select_name}'); sampAddChatMessage('Тег скопирован!', -1) end
		imgui.SameLine(); imgui.TextColoredRGB('Получает Ник игрока с которым взаимодействуете')
		if imgui.Button('{select_rp_name}', imgui.ImVec2(120, 25)) then setClipboardText('{select_name}'); sampAddChatMessage('Тег скопирован!', -1) end
		imgui.SameLine(); imgui.TextColoredRGB('Получает РП Ник игрока с которым взаимодействуете')
		if imgui.Button('{my_id}', imgui.ImVec2(120, 25)) then setClipboardText('{my_id}'); sampAddChatMessage('Тег скопирован!', -1) end
		imgui.SameLine(); imgui.TextColoredRGB('Получает ваш Ид')
		if imgui.Button('{my_name}', imgui.ImVec2(120, 25)) then setClipboardText('{my_name}'); sampAddChatMessage('Тег скопирован!', -1) end
		imgui.SameLine(); imgui.TextColoredRGB('Получает ваш Ник')
		if imgui.Button('{my_rp_name}', imgui.ImVec2(120, 25)) then setClipboardText('{my_name}'); sampAddChatMessage('Тег скопирован!', -1) end
		imgui.SameLine(); imgui.TextColoredRGB('Получает ваш РП Ник')
		if imgui.Button('{nearest_id}', imgui.ImVec2(120, 25)) then setClipboardText('{nearest_id}'); sampAddChatMessage('Тег скопирован!', -1) end
		imgui.SameLine(); imgui.TextColoredRGB('Получает Ид ближайшего к вам игрока')
		if imgui.Button('{nearest_name}', imgui.ImVec2(120, 25)) then setClipboardText('{nearest_name}'); sampAddChatMessage('Тег скопирован!', -1) end
		imgui.SameLine(); imgui.TextColoredRGB('Получает Ник ближайшего к вам игрока')
		if imgui.Button('{nearest_rp_name}', imgui.ImVec2(120, 25)) then setClipboardText('{nearest_name}'); sampAddChatMessage('Тег скопирован!', -1) end
		imgui.SameLine(); imgui.TextColoredRGB('Получает РП Ник ближайшего к вам игрока')
		if imgui.Button('{time}', imgui.ImVec2(120, 25)) then setClipboardText('{time}'); sampAddChatMessage('Тег скопирован!', -1) end
		imgui.SameLine(); imgui.TextColoredRGB('Получает текущее время ( чч:мм )')
		if imgui.Button('{time_s}', imgui.ImVec2(120, 25)) then setClipboardText('{time_s}'); sampAddChatMessage('Тег скопирован!', -1) end
		imgui.SameLine(); imgui.TextColoredRGB('Получает текущее время ( чч:мм:сс )')
		imgui.Separator()
		if imgui.Button(u8'Вернуться назад##tag', imgui.ImVec2(-1, 30)) then
			imgui.CloseCurrentPopup()
		end
		imgui.EndPopup()
	end
end

function sp.onSendCommand(text)

    if text:lower() == '/klad' then
        if pos_x == nil then
			sampAddChatMessage('[MRH] {ffffff}Позиция клада не найдена!', ini.config.clrtext)
		else
			placeWaypoint(pos_x, pos_y, pos_z)
		end
        return false
    end
	
	if text:lower() == "//rec" then
		sampDisconnectWithReason(false)
		sampSetGamestate(1)
		return false
	end

	if text:lower() == "/testvk" then
		sendvknotf('\nТестовое сообщение...')
		return false
	end

	if text:lower() == "/mrh" then
		igvars.main_window_state.v = not igvars.main_window_state.v
		return false
	end

	if text:lower() == "/dbug" then
		tr.dbug = not tr.dbug
		sampAddChatMessage(tr.dbug and 'debug mode enable' or 'debug mode disable', -1)
		return false
	end

	if text:lower() == "/mrh.r" then
		sampAddChatMessage('[MRH] {ffffff}Скрипт перезапущен', ini.config.clrtext)
		tr.reloadR = true
		thisScript():reload()
		return false
	end

	if text:lower() == '/rklad' then
		if tr.isEnableklad then 
			tr.isEnableklad = false
			igvars.isEnableklad.v = false
		else
			get_coords(true)
			tr.isEnableklad = true
			igvars.isEnableklad.v = true
			lua_thread.create(klad3d, true)
		end 
        return false
    end

	if text:find('{select_id}') then
		local result, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
		if result then
			local res, actionId = sampGetPlayerIdByCharHandle(ped)
			if actionId ~= nil then
				text = text:gsub('{select_id}', actionId)
				return { text }
			end
		end
		sampAddChatMessage('[MRH] {ffffff}Вы ещё не отметили игрока для тега {select_id}', ini.config.clrtext)
		return false
	end

	if text:find('{select_name}') then
		local result, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
		if result then
			local res, actionId = sampGetPlayerIdByCharHandle(ped)
			if actionId ~= nil then
				text = text:gsub('{select_name}', nonRpNick(actionId))
				return { text }
			end
		end
		sampAddChatMessage('[MRH] {ffffff}Вы ещё не отметили игрока для тега {select_name}', ini.config.clrtext)
		return false
	end

	if text:find('{select_rp_name}') then
		local result, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
		if result then
			local res, actionId = sampGetPlayerIdByCharHandle(ped)
			if actionId ~= nil then
				text = text:gsub('{select_rp_name}', rpNick(actionId))
				return { text }
			end
		end
		sampAddChatMessage('[MRH] {ffffff}Вы ещё не отметили игрока для тега {select_rp_name}', ini.config.clrtext)
		return false
	end

	if text:find('{my_id}') then
		local id = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
		text = text:gsub('{my_id}', tostring(id))
		return { text }
	end

	if text:find('{my_name}') then
		local id = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
		text = text:gsub('{my_name}', nonRpNick(id))
		return { text }
	end

	if text:find('{my_rp_name}') then
		local id = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
		text = text:gsub('{my_rp_name}', rpNick(id))
		return { text }
	end

	if text:find('{nearest_id}') then
		local result, id = getClosestPlayerId()
		if result then
			text = text:gsub('{nearest_id}', tostring(id))
			return { text }
		end
		sampAddChatMessage('[MRH] {ffffff}В вашем радиусе нет игроков для применения тега {nearest_id}', ini.config.clrtext)
		return false
	end

	if text:find('{nearest_name}') then
		local result, id = getClosestPlayerId()
		if result then
			text = text:gsub('{nearest_name}', nonRpNick(id))
			return { text }
		end
		sampAddChatMessage('[MRH] {ffffff}В вашем радиусе нет игроков для применения тега {nearest_name}', ini.config.clrtext)
		return false
	end
	
	if text:find('{nearest_rp_name}') then
		local result, id = getClosestPlayerId()
		if result then
			text = text:gsub('{nearest_rp_name}', rpNick(id))
			return { text }
		end
		sampAddChatMessage('[MRH] {ffffff}В вашем радиусе нет игроков для применения тега {nearest_rp_name}', ini.config.clrtext)
		return false
	end

	if text:find('{time}') then
		text = text:gsub('{time}', os.date("%H:%M", os.time()))
		return { text }
	end

	if text:find('{time_s}') then
		text = text:gsub('{time_s}', os.date("%H:%M:%S", os.time()))
		return { text }
	end

	if text:find('{screen}') then
		sampSendChat('/time')
		text = text:gsub('{screen}', '')
		return #text > 0 and { text } or false
	end
end

function sp.onVehicleStreamIn()
	if togglecar then 
		return false
	end
end

function getClosestPlayerId()
	local temp = {}
	local tPeds = getAllChars()
	local me = {getCharCoordinates(PLAYER_PED)}
	for i, ped in ipairs(tPeds) do 
		local result, id = sampGetPlayerIdByCharHandle(ped)
		if ped ~= PLAYER_PED and result then
			local pl = {getCharCoordinates(ped)}
			local dist = getDistanceBetweenCoords3d(me[1], me[2], me[3], pl[1], pl[2], pl[3])
			temp[#temp + 1] = { dist, id }
		end
	end
	if #temp > 0 then
		table.sort(temp, function(a, b) return a[1] < b[1] end)
		return true, temp[1][2]
	end
	return false
end


function hidecars()
	togglecar = not togglecar
  	if togglecar then
  		local cars = getAllVehicles()
		for i = 1, #cars do
			local res, id = sampGetVehicleIdByCarHandle(cars[i])
	  		if res and cars[i] ~= 1 then
	  			hideCar(id)
	  		end
		end
  	end
end

function hideCar(id)
	local w = bitsio.bs_write
	local bs = raknetNewBitStream()
	w.int16(bs, id)
	raknetEmulRpcReceiveBitStream(165, bs)
end

local cmd_repbool = false

function cmd_rep(arg)
	if #arg == 0 then
		sampSendChat('/rep')
	else
		cmd_repbool = true
		sampSendChat('/rep')
		sampSendDialogResponse(32, 1, 0, arg)
	end
end

function sendchatirc()
	si:sendChat(channel_osnova, u8(tempField))
end

function chatfam(text)
	if si_status then
		if text == "" then sampAddChatMessage("[MRH/Chat] {ffffff}Используй: /cf [сообщение]", ini.config.clrtext) return end
		--local toNick, msg = string.match(text, "(%S+) (.*)$")
		if os.time() - lastMessage > 0.5 then
			if not si_thinkbool then
				tempField = 'cfchat '..text
				ircsend = xpcall(sendchatirc, myerrorhandler)
				--si:sendChat(channel_osnova, u8('cfchat '..text))
				if ircsend then 
					sampAddChatMessage(string.format("[EVREI CHAT]{ffffff} %s: %s", nick_id, text), 0xA77BCA)
				end
				tempField = ''
				lastMessage = os.time()
			else
				sampAddChatMessage("[MRH] {A77BCA}Произошла ошибка!", ini.config.clrtext)
			end
		else
			sampAddChatMessage("[MRH] {A77BCA}Не флуди!", ini.config.clrtext)
		end
	else
		sampAddChatMessage("[MRH] {A77BCA}Вы отключены от чата. Попробуйте перезагрузить скрипт.", ini.config.clrtext)
	end
end

function chatrep(text)
	if si_status then
		if text == "" then sampAddChatMessage("[MRH] {ffffff}Используй: /crep [репорт]", ini.config.clrtext) return end
		--local toNick, msg = string.match(text, "(%S+) (.*)$")
		if os.time() - lastMessage > 0.5 then
			if not si_thinkbool then
				result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
				tempField = 'cfrep '..id..' '..text
				ircsend = xpcall(sendchatirc, myerrorhandler)
				--si:sendChat(channel_osnova, u8('cfrep '..id..' '..text))
				if ircsend then 
					sampAddChatMessage(string.format("[EVREI CHAT]{ffffff} Отправлен репорт: %s", text), 0xA77BCA)
				end
				tempField = ''
				lastMessage = os.time()
			else
				sampAddChatMessage("[MRH] {A77BCA}Произошла ошибка!", ini.config.clrtext)
			end
		else
			sampAddChatMessage("[MRH] {A77BCA}Не флуди!", ini.config.clrtext)
		end
	else
		sampAddChatMessage("[MRH] {A77BCA}Вы отключены от чата. Попробуйте перезагрузить скрипт.", ini.config.clrtext)
	end
end

function chatpos(text)
	if si_status then
		if text == "" then sampAddChatMessage("[MRH] {ffffff}Используй: /cpos [id/nick]", ini.config.clrtext) return end
		--local toNick, msg = string.match(text, "(%S+) (.*)$")
		if os.time() - lastMessage > 0.5 then
			if not si_thinkbool then
				tempField = 'cfgetpos '..text..' '..nick_player
				ircsend = xpcall(sendchatirc, myerrorhandler)
				--si:sendChat(channel_osnova, u8('cfrep '..id..' '..text))
				if ircsend then 
					sampAddChatMessage("[EVREI CHAT]{ffffff} Запрос отправлен", 0xA77BCA)
				end
				tempField = ''
				lastMessage = os.time()
			else
				sampAddChatMessage("[MRH] {A77BCA}Произошла ошибка!", ini.config.clrtext)
			end
		else
			sampAddChatMessage("[MRH] {A77BCA}Не флуди!", ini.config.clrtext)
		end
	else
		sampAddChatMessage("[MRH] {A77BCA}Вы отключены от чата. Попробуйте перезагрузить скрипт.", ini.config.clrtext)
	end
end


function Search3Dtext(x, y, z, radius, patern) -- https://www.blast.hk/threads/13380/post-119168
    local text = ""
    local color = 0
    local posX = 0.0
    local posY = 0.0
    local posZ = 0.0
    local distance = 0.0
    local ignoreWalls = false
    local player = -1
    local vehicle = -1
    local result = false

    for id = 0, 2048 do
        if sampIs3dTextDefined(id) then
            local text2, color2, posX2, posY2, posZ2, distance2, ignoreWalls2, player2, vehicle2 = sampGet3dTextInfoById(id)
            if getDistanceBetweenCoords3d(x, y, z, posX2, posY2, posZ2) < radius then
                if string.len(patern) ~= 0 then
                    if string.match(text2, patern, 0) ~= nil then result = true end
                else
                    result = true
                end
                if result then
                    text = text2
                    color = color2
                    posX = posX2
                    posY = posY2
                    posZ = posZ2
                    distance = distance2
                    ignoreWalls = ignoreWalls2
                    player = player2
                    vehicle = vehicle2
                    radius = getDistanceBetweenCoords3d(x, y, z, posX, posY, posZ)
                end
            end
        end
    end

    return result, text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle
end

function tempnick()
	result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	nick_id = nick_player..'['..id..']'
	si:send("NICK %s", nick_id)
end

function clickupdwait()
	lua_thread.create(function()
		tr.clickupd = false
		wait(5000)
		if not upd_state then
			tr.clickupd = true
		end
	end)
end

function onIRCMessage(user, channel, message)
	local typechat, msg = string.match(message, "(%S+) (.*)$")
	if typechat == 'cfchat' then
    	sampAddChatMessage(u8:decode(string.format("[EVREI CHAT]{FFFFFF} %s: %s", user.nick, msg)), 0xA77BCA)
	elseif typechat == 'vipchat' then
		if igvars.vipchat.v then
			sampAddChatMessage(u8:decode(string.format("%s", msg)), -1)
		end
	elseif typechat == 'cfrep' then
		local cfidrep, chatfrep = string.match(msg, "(%d+) (.*)$")
		sampAddChatMessage(string.format("[EVREI CHAT]{FFFFFF} Репорт от %s: %s (Принять форму ALT + 9)", user.nick, u8:decode(chatfrep)), 0xA77BCA)
		
		active_forma = true
		formarep(u8:decode(chatfrep), cfidrep)
	elseif typechat == 'cfgetpos' then
		local cfidpos, chatfpos = string.match(msg, "(%d+) (.*)$")
		result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		nick_player = sampGetPlayerNickname(id)
		if cfidpos == tostring(id) or cfidpos == nick_player then
			sampAddChatMessage(string.format("[EVREI CHAT]{FFFFFF} Запрос геолокации игроком %s (Принять форму ALT + 8)", user.nick), 0xA77BCA)
			active_forma2 = true
			formagetpos(chatfpos)
		end
	elseif typechat == 'cfrepac' then
		sampAddChatMessage(string.format("[EVREI CHAT]{FFFFFF} %s принял репорт.", user.nick), 0xA77BCA)
		stop_forma = true
	elseif typechat == 'cfgpac' then
		local cnickpos, ccordspos = string.match(msg, "(%S+) (.*)$")
		if cnickpos == nick_player then
			local xq, yq, zq = string.match(ccordspos, "(%S+) (%S+) (%S+)")
			setMarker(1, tonumber(xq), tonumber(yq), tonumber(zq), 3)
			sampAddChatMessage(string.format("[EVREI CHAT]{FFFFFF} На карте отмемечена геолокация игрока.", user.nick), 0xA77BCA)
		end
	elseif typechat == 'cfklad' then
		sampAddChatMessage(u8:decode(string.format("[EVREI CHAT]{FFFFFF} %s", msg)), 0xA77BCA)
	end
end

function onIRCDisconnect(message, error)
	if si_status then
		if error then
			if connected then
				connected = false
				si:disconnect()
				sampAddChatMessage("[MRH] {0xA77BCA}Вы были отключены от сервера (чата) за AFK", ini.config.clrtext)
			end
		end
	end
end

function saveJson(data, path)
    if doesFileExist(path) then os.remove(path) end
    if type(data) ~= 'table' then return end
    local f = io.open(path, 'a+')
    local writing_data = encodeJson(data)
    f:write(writing_data)
    f:close()
end

function sp.onRemoveBuilding()
	if joinCount > 1 then return false end
end

function sp.onPlayerChatBubble(id, col, dist, dur, msg)
	if flymode == 1 then
		return {id, col, 1488, dur, msg}
	end
end

function sp.onSendClientJoin(Ver, mod, nick, response, authKey, clientver, unk)
	joinCount = joinCount + 1
	if igvars.arz_laun.v then
		clientver = 'Arizona PC'
		return {Ver, mod, nick, response, authKey, clientver, unk}
	end
end

function onScriptTerminate(script, quitGame)
	if script == thisScript() then
		stop_downloading = true
		showCursor(false)
		--saveSettings(1)
		saveJson(cfg1, jsonDir) 
		saveJson(cfg2, jsonDir2)
		inicfg.save(cfg, d_ini)

		if not tr.reloadR and not upd_state2 then
			sampAddChatMessage("[MRH] {FF4848}Скрипт умер.", ini.config.clrtext)
		end		if not tr.reloadR and igvars.vknotf.v and igvars.vk_crash.v then
			sendvknotf('\nСкрипт умер')
		end

		if doesFileExist(file) then
			os.remove(file)
		end
		local f = io.open(file, "w")
		if f then
			f:write(encodeJson(tBindList))
			f:close()
		end
	end
end

function join_argb(a, r, g, b)
    local argb = b  -- b
    argb = bit.bor(argb, bit.lshift(g, 8))  -- g
    argb = bit.bor(argb, bit.lshift(r, 16)) -- r
    argb = bit.bor(argb, bit.lshift(a, 24)) -- a
    return argb
end


function homejoin()
	lua_thread.create(function() wait(0)
		tr.homejoinbool = true
		sampSendChat("/house")
		sampSendDialogResponse(174, 1, 0, -1)
		setGameKeyState(21, 255)
		wait(1)
		sampSendChat("/house")
		sampSendDialogResponse(174, 1, 0, -1)
		wait(3000)
		tr.homejoinbool = false
	end)
end
function isKeyCheckAvailable()
	if not isSampLoaded() then
		return true
	end
	if not isSampfuncsLoaded() then
		return not sampIsChatInputActive() and not sampIsDialogActive()
	end
	return not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive()
end

lua_thread.create(function()
	while true do
		wait(30)
		if isKeyDown(17) and isKeyDown(82) then
			tr.reloadR = true
			inicfg.save(cfg, d_ini)
		end
	end
end)

function invfix()
	lua_thread.create(function() wait(0)
		tr.ifix = true
		sampSendChat("/donate")
		wait(3000)
		tr.ifix = false
	end)
end

function sp.onSetPlayerDrunk(drunkLevel)
	if igvars.antilomka.v then
    	return {1}
	end
end

function sp.onDisplayGameText(style, time, text)
	if not isCharInAnyCar(1) then
		if text:find('Press: ~g~Y') then
			_, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
			RakNet = allocateMemory(68)
			sampStorePlayerOnfootData(myId, RakNet)
			setStructElement(RakNet, 36, 1, 64, false)
			sampSendOnfootData(RakNet)
			sampSendOnfootData(RakNet)
			freeMemory(RakNet)
		end
		if text:find('Press: ~r~N') then
			_, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
			RakNet = allocateMemory(68)
			sampStorePlayerOnfootData(myId, RakNet)
			setStructElement(RakNet, 36, 1, 128, false)
			sampSendOnfootData(RakNet)
			sampSendOnfootData(RakNet)
			freeMemory(RakNet)
		end
	end
	if igvars.checkmethod.v == 0 and igvars.autohawk.v then
		if text == ('You are hungry!') or text == ('~r~You are very hungry!') then
			gotoeatinhouse = true
			sampSendChat('/home')
		end
	end 
	if style == 3 and time == 1000 and text:find("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Jailed %d+ Sec%.") then
		local c, _ = math.modf(tonumber(text:match("Jailed (%d+)")) / 60)
		return {style, time, string.format("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Jailed %s Sec = %s Min.", text:match("Jailed (%d+)"), c)}
	end
end


function cmd_reptemp()
	if cmd_repbool then
		lua_thread.create(function() wait(1)
			cmd_repbool = false
		end)
	else
		igvars.new_report.v = true
		focus = true
	end
end

function sp.onShowDialog(id, style, title, button1, button2, text)
	if gotoeatinhouse then
		local linelist = 0
		for n in text:gmatch('[^\r\n]+') do
			if id == 174 and n:find('Меню дома') then
				sampSendDialogResponse(174, 1, linelist, false)
			elseif id == 2431 and n:find('Холодильник') then
				sampSendDialogResponse(2431, 1, linelist, false)
			elseif id == 185 and n:find('Комплексный Обед') then
				sampSendDialogResponse(185, 1, linelist-1, false)
				gotoeatinhouse = false
			end
			linelist = linelist + 1
		end
		if text:find('недвижимости') then
			gotoeatinhouse = false
		end
		return false
	end
	if text:find("Следовательно вашему наказанию") then
		tsrbox = text:match("Перенести (.+) ящиков")
		tsreda = text:match("Приготовить (.+) порций еды")
		tsrodejda = text:match("Перестирать (.+) грязной одежды")
		tsrtrash = text:match("вынести на мусорку (.+) мусора")
		tsrtime = text:match("Отсидеть (.+) минут в")
		--sampAddChatMessage('Ящики: '..tsrbox, -1)
		--sampAddChatMessage('Еда: '..tsreda, -1)
		--sampAddChatMessage('Одежда: '..tsrodejda, -1)
		--sampAddChatMessage('Мусор: '..tsrtrash, -1)
		--sampAddChatMessage('Время: '..tsrtime, -1)
	end
	if id == 0 and title:find('Подсказка') and text:find('В этом месте запрещено') then 
		sampAddChatMessage('[MRH:Hint] {ffffff}В этом месте запрещено наносить урон!', ini.config.clrtext) 
		return false
	end
	if text:find('Вы были кикнуты за подозрение в читерстве') then
		for line in text:gmatch("[^\n]+") do
			if line:find('Код причины:') then
				local reason_kick = line:match("Код причины: (.+)")
				sampAddChatMessage('[MRH:Hint] {ffffff}Вы были кикнуты за подозрение в читерстве ['..reason_kick..']', ini.config.clrtext)
			end
		end
		sampDisconnectWithReason(quit)
		sampSetGamestate(1)
	end
	if id == 25012 then
		vkoinsev = title:match("Всего: (.+) в")
		igvars.window_vkoin.v = true
	end
	if igvars.savedialog.v then
		if style == 2 then
			dialogIncoming = id
		end
	end
	if id == 32 then
		cmd_reptemp()
		return false
    end
	if tr.dbug then
		sampAddChatMessage('id dialog: '..id, -1)
	end
	if tr.ifix and text:find("Курс пополнения счета") then
		sampAddChatMessage("[MRH:Hint] {ffffff}Пофикшено!", ini.config.clrtext)
		sampSendDialogResponse(id,0,0,'')
		return false
	end
	if tr.homejoinbool and id == 174 then
		sampSendDialogResponse(id,0,0,'')
		return false
	end
	if id == (2) then
		ircnick = xpcall(tempnick, myerrorhandler)
		if igvars.auto_l.v and igvars.nick_n.v == nick_player and not text:find('Неверный пароль!') then
			sampSendDialogResponse(id, 1, _, ini.config.parol)
			return false
		elseif igvars.auto_l.v and igvars.nick_n.v == nick_player and text:find('Неверный пароль!') then
			sampAddChatMessage('[MRH] {ffffff}В настройках указан неверный пароль!', ini.config.clrtext)
		end
	end
	if igvars.auto_p.v and id == (991) then
		sampSendDialogResponse(id, 1, _, ini.config.pincod)
		return false
	end
	if sendstatsstate and id == 235 then
		sampSendDialogResponse(id,0,0,'')
		sendstatsstate = text
		return false
	end
	if igvars.dialog_trash.v then
		if text:find("Перед тем как подтвердить сделку, советуем всё тщательно перепроверить") and id == 0 then
			sampSendDialogResponse(0, 1 , nil, nil)
			return false
		end
		if id == 15330 then
			invfix()
			return false
		end
		if id == 1332 then
			sampSendDialogResponse(1332, 1, nil, nil)
			return false
		end
	end
	if id == 13101 and igvars.answer_k.v then
		if answ_klad then
			for i, B in ipairs(answ_klad) do
				if text:lower():find(B[1]:lower()) then
					text = text:gsub('\n\n(Введите ответ .+)', '\n\nОтвет на вопрос: ' .. B[2] .. '\n\n{FFFFFF}%1')
					--sampAddChatMessage('debug/ ответ:' .. B[2], -1)
					--lua_thread.create(function() wait(50)
					--	sampSetCurrentDialogEditboxText(B[2])
					--end)
				end
			end
			return {id, style, title, button1, button2, text}
		else
			sampAddChatMessage('[MRH:Hint] {ffffff}Ответы не загружены.', ini.config.clrtext)
		end
	end
	if id == 235 then
		if title:find("Основная статистика") then
			text = separator(text)
			return {id, style, title, button1, button2, text}
		end
	end
end
function sp.onCreateObject(objectId, data)
    if data.modelId == 2680 and igvars.klad.v then
		pos_x = data.position.x
		pos_y = data.position.y
		pos_z = data.position.z
		x2, y2, z2 = getCharCoordinates(PLAYER_PED)
		distance = string.format("%.1f", getDistanceBetweenCoords3d(pos_x, pos_y, pos_z, x2, y2, z2))
		if tonumber(distance) < 80 then
			if tonumber(distance) > 30 then
				addNotify("{ff3333}Найден клад [Фейк клад]\n{ffffff}Дистанция до клада: ".. distance, 20)
			else 
				addNotify("{ff3333}Найден клад\n{ffffff}Дистанция до клада: ".. distance, 20)
			end
		end
    end
end

function sp.onShowTextDraw(id, data)
	if igvars.autobike.v and id == 2067 and data.text == 'your progress' and not bool_bike then
		bool_bike = true
		lua_thread.create(auto_bike, id)
	end
    if check_chest then
        lua_thread.create(function()
            if data.modelId == 19918 then
				while sampIsDialogActive() do
					sampCloseCurrentDialogWithButton(0)
					wait(500)
				end
				wait(111)
                sampSendClickTextdraw(id)
				tdid = id
                use1 = true
            end
		end)
        if data.text == 'USE' then
            local clickID = id + 1
            sampSendClickTextdraw(clickID)
            use1 = false
			local d_td = sampTextdrawGetString(tdid + 1)
			if d_td ~= nil then
				wTime = string.match(d_td, ".+")
				if wTime == 'LD_SPAC:white' then
					if openchestvk or igvars.vkcheststart.v then
						--sendvknotf("\nВы успешно использовали сундук с рулетками")
						tr.ruletka = true
						if openchestvk then openchestvk = false end
						check_chest1()
					end
				else
					waitchest()
					if openchestvk then
						sendvknotf("\nОсталось: "..wTime)
						openchestvk = false
					end
					sampSendClickTextdraw(65535)
					check_chest = false
				end
            end
		end
    end
end

function waitchest()
	local wTimewait = wTime:match('(%d+)')
	if wTime:find('min') then
		mMin = wTimewait-1
		Activated = true
		lua_thread.create(function()
			wait(wTimewait * 59975)
			if igvars.autochest.v and tr.openStartChest.v then
				check_chest = true
				sampSendClickTextdraw(65535)
				wait(500)
				sampSendChat("/invent")
			end
		end)
	elseif wTime:find('sec') then
		mMin = 0
		sSec = wTimewait-1
		Activated = true
		lua_thread.create(function()
			wait(wTimewait * 975)
			if igvars.autochest.v and tr.openStartChest.v then
				check_chest = true
				sampSendClickTextdraw(65535)
				wait(500)
				sampSendChat("/invent")
			end
		end)
	end
end

function sp.onSendDialogResponse(dialogId , button , listboxId , input)
	if igvars.savedialog.v then
		dialogs_data[dialogId] = {listboxId, input}
	end
	if dialogId == 25012 and button == 0 then 
		igvars.window_vkoin.v = false
	end
end

function onReceiveRpc(id,bs)
    if id == 44 then 
        local id = raknetBitStreamReadInt16(bs)
        local model = raknetBitStreamReadInt32(bs)
        if FINDmap(model) then 
            return false 
        end
    end
end
function FINDmap(model)
    if igvars.kystibool.v then
        for k, v in pairs(kysti) do
            if model == v then 
                return true 
            end
        end
    end
end

function getbalance()
	local t = igvars.phoneint.v + 1
	if sampTextdrawIsExists(ids['phones'][t]['tdBalance']) then
		for s in ipairs(charsvk) do
			if sampTextdrawGetString(ids['phones'][t]['tdBalance']):find(charsvk[s]) then
				return nil
			end
		end
		return sampTextdrawGetString(ids['phones'][t]['tdBalance'])
	end
	return nil
end

function formarep(reptext, repid)
	if si_status then
		if active_forma then
			lua_thread.create(function()
				lasttime = os.time()
				lasttimes = 0
				time_out = 7
				active_keys = true
				while lasttimes < time_out and active_forma do
					lasttimes = os.time() - lasttime
					wait(0)
					printStyledString("REPORT FORM " .. time_out - lasttimes .. " WAIT", 1000, 4)
					if lasttimes == time_out then
						active_forma = false
						printStyledString("Forma skipped", 1000, 4)
					end
					if active_keyson and not sampIsChatInputActive() and not sampIsDialogActive() then
						printStyledString("Report form accepted", 1000, 4)

						cmd_repbool = true
						sampSendChat('/rep')
						sampSendDialogResponse(32, 1, 0, repid..' '..reptext)
						--si:sendChat(channel_osnova, u8('cfrepac +'))
						tempField = 'cfrepac +'
						ircsend = xpcall(sendchatirc, myerrorhandler)
						wait(1000)
						tempField = ''
						active_keyson = false
						active_forma = false
					end
					if stop_forma then
						active_forma = false
						break
					end
				end
			end)
		end
	end
end

function formagetpos(nickgetpos)
	if si_status then
		if active_forma2 then
			lua_thread.create(function()
				lasttime = os.time()
				lasttimes = 0
				time_out = 7
				active_keys2 = true
				while lasttimes < time_out and active_forma2 do
					lasttimes = os.time() - lasttime
					wait(0)
					printStyledString("GET POS FORM " .. time_out - lasttimes .. " WAIT", 1000, 4)
					if lasttimes == time_out then
						active_forma2 = false
						printStyledString("Forma skipped", 1000, 4)
					end
					if active_keyson2 and not sampIsChatInputActive() and not sampIsDialogActive() then
						printStyledString("Pos form accepted", 1000, 4)
						local qX, qY, qZ = getCharCoordinates(PLAYER_PED)
						--si:sendChat(channel_osnova, u8('cfgpac +'))
						tempField = 'cfgpac '..nickgetpos..' '..tostring(qX)..' '..tostring(qY)..' '..tostring(qZ)
						ircsend = xpcall(sendchatirc, myerrorhandler)
						wait(1000)
						tempField = ''
						active_keyson2 = false
						active_forma2 = false
					end
				end
			end)
		end
	end
end
function sp.onSetPlayerHealth(healthfloat)
	if igvars.healstate.v and igvars.autohawk.v and sampIsLocalPlayerSpawned() then
		if healthfloat <= igvars.hplvl.v then
			if igvars.hpmetod.v == 0 then
				sampAddChatMessage('[MRH] {ffffff}Не работает', ini.config.clrtext)
			elseif igvars.hpmetod.v == 1 then
				sampSendChat('/usedrugs 3')
			end
		end   
	end
end

function sp.onSendPlayerSync(data)
	if igvars.bhop.v then
		if bit.band(data.keysData, 0x28) == 0x28 then
			data.keysData = bit.bxor(data.keysData, 0x20)
		end
	end
end

function remove_f()
	if doesFileExist(getGameDirectory()..'\\_ci.removeasi') then
		os.remove(getGameDirectory()..'\\_ci.removeasi')
	end
	if doesFileExist(getGameDirectory()..'\\zlib1.removedll') then
		os.remove(getGameDirectory()..'\\zlib1.removedll')
	end
	if doesFileExist(getGameDirectory()..'\\_ci.removeini') then
		os.remove(getGameDirectory()..'\\_ci.removeini')
	end
	if doesFileExist(getGameDirectory()..'\\_dialogs.removeasi') then
		os.remove(getGameDirectory()..'\\_dialogs.removeasi')
	end
	if doesFileExist(getGameDirectory()..'\\fastman92limitAdjuster_GTASA.removeini') then
		os.remove(getGameDirectory()..'\\fastman92limitAdjuster_GTASA.removeini')
	end
	if doesFileExist(getGameDirectory()..'\\MinHook.x86.removedll') then
		os.remove(getGameDirectory()..'\\MinHook.x86.removedll')
	end
	if doesFileExist(getGameDirectory()..'\\DllTricks.removedll') then
		os.remove(getGameDirectory()..'\\DllTricks.removedll')
	end
	if doesFileExist(getGameDirectory()..'\\$fastman92limitAdjuster.asi.removeasi') then
		os.remove(getGameDirectory()..'\\$fastman92limitAdjuster.asi.removeasi')
	end
	if doesFileExist(getGameDirectory()..'\\data\\gtasa_vehicleAudioSettings.removecfg') then
		os.remove(getGameDirectory()..'\\data\\gtasa_vehicleAudioSettings.removecfg')
	end
	if doesFileExist(getGameDirectory()..'\\core.removeasi') then
		os.remove(getGameDirectory()..'\\core.removeasi')
	end
	print('Удалил ненужные файлы')
end

function dlmodel_upd()
	if doesFileExist(getGameDirectory()..'\\core.asi') then
		os.rename(getGameDirectory()..'\\core.asi', getGameDirectory()..'\\core.removeasi')
	end
	if doesFileExist(getGameDirectory()..'\\_ci.asi') then
		os.rename(getGameDirectory()..'\\_ci.asi', getGameDirectory()..'\\_ci.removeasi')
	end
	if doesFileExist(getGameDirectory()..'\\_ci.ini') then
		os.rename(getGameDirectory()..'\\_ci.ini', getGameDirectory()..'\\_ci.removeini')
	end
	if doesFileExist(getGameDirectory()..'\\zlib1.dll') then
		os.rename(getGameDirectory()..'\\zlib1.dll', getGameDirectory()..'\\zlib1.removedll')
	end
	if doesFileExist(getGameDirectory()..'\\_dialogs.asi') then
		os.rename(getGameDirectory()..'\\_dialogs.asi', getGameDirectory()..'\\_dialogs.removeasi')
	end
	if doesFileExist(getGameDirectory()..'\\fastman92limitAdjuster_GTASA.ini') then
		os.rename(getGameDirectory()..'\\fastman92limitAdjuster_GTASA.ini', getGameDirectory()..'\\fastman92limitAdjuster_GTASA.removeini')
	end
	if doesFileExist(getGameDirectory()..'\\MinHook.x86.dll') then
		os.rename(getGameDirectory()..'\\MinHook.x86.dll', getGameDirectory()..'\\MinHook.x86.removedll')
	end
	if doesFileExist(getGameDirectory()..'\\DllTricks.dll') then
		os.rename(getGameDirectory()..'\\DllTricks.dll', getGameDirectory()..'\\DllTricks.removedll')
	end
	if doesFileExist(getGameDirectory()..'\\$fastman92limitAdjuster.asi') then
		os.rename(getGameDirectory()..'\\$fastman92limitAdjuster.asi', getGameDirectory()..'\\$fastman92limitAdjuster.asi.removeasi')
	end
	if doesFileExist(getGameDirectory()..'\\data\\gtasa_vehicleAudioSettings.cfg') then
		os.rename(getGameDirectory()..'\\data\\gtasa_vehicleAudioSettings.cfg', getGameDirectory()..'\\data\\gtasa_vehicleAudioSettings.removecfg')
	end

	sampAddChatMessage('{ff0000}Выйдите из игры и удалите папку modpack в корне игры, после нажмите на кнопку скачать модели.',-1)
	sampAddChatMessage('{ff0000}Выйдите из игры и удалите папку modpack в корне игры, после нажмите на кнопку скачать модели.',-1)
	sampAddChatMessage('{ff0000}Выйдите из игры и удалите папку modpack в корне игры, после нажмите на кнопку скачать модели.',-1)
	
end

function dlmodel()
	if not doesDirectoryExist(getGameDirectory()..'\\modpack') then
		createDirectory(getGameDirectory()..'\\modpack')
	end

	if not doesFileExist(getGameDirectory()..'\\modpack\\arizona.ide') then
		download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/arz/modpack/arizona.ide', 
					getGameDirectory()..'\\modpack\\arizona.ide', download_handler)
		while not doesFileExist(getGameDirectory()..'\\modpack\\arizona.ide') do wait(0) end
		dl_files = 1
	end
	if not doesFileExist(getGameDirectory()..'\\modpack\\default.dat') then
		download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/arz/modpack/default.dat', 
					getGameDirectory()..'\\modpack\\default.dat', download_handler)
		while not doesFileExist(getGameDirectory()..'\\modpack\\default.dat') do wait(0) end
		dl_files = 2
	end
	if not doesFileExist(getGameDirectory()..'\\modpack\\gtasa_vehicleAudioSettings.cfg') then
		download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/arz/modpack/gtasa_vehicleAudioSettings.cfg', 
					getGameDirectory()..'\\modpack\\gtasa_vehicleAudioSettings.cfg', download_handler)
		while not doesFileExist(getGameDirectory()..'\\modpack\\gtasa_vehicleAudioSettings.cfg') do wait(0) end
		dl_files = 3
	end
	if not doesFileExist(getGameDirectory()..'\\modpack\\handling.cfg') then
		download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/arz/modpack/handling.cfg', 
					getGameDirectory()..'\\modpack\\handling.cfg', download_handler)
		while not doesFileExist(getGameDirectory()..'\\modpack\\handling.cfg') do wait(0) end
		dl_files = 4
	end
	if not doesFileExist(getGameDirectory()..'\\modpack\\vinils.txd') then
		download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/arz/modpack/vinils.txd', 
					getGameDirectory()..'\\modpack\\vinils.txd', download_handler)
		while not doesFileExist(getGameDirectory()..'\\modpack\\vinils.txd') do wait(0) end
		dl_files = 5
	end
	if not doesFileExist(getGameDirectory()..'\\modpack\\arz-vehicles-2.img') then
		download_id = downloadUrlToFile('https://gitlab.com/lon3y/1/-/raw/main/arz-vehicles-2.img', 
					getGameDirectory()..'\\modpack\\arz-vehicles-2.img', download_handler)
		while not doesFileExist(getGameDirectory()..'\\modpack\\arz-vehicles-2.img') do wait(0) end
		dl_files = 6
	end
	if not doesFileExist(getGameDirectory()..'\\modpack\\arz-vehicles.img') then
		download_id = downloadUrlToFile('https://gitlab.com/lon3y/1/-/raw/main/arz-vehicles.img', 
					getGameDirectory()..'\\modpack\\arz-vehicles.img', download_handler)
		while not doesFileExist(getGameDirectory()..'\\modpack\\arz-vehicles.img') do wait(0) end
		dl_files = 7
	end
	if not doesFileExist(getGameDirectory()..'\\modpack\\arz-skins.img') then
		download_id = downloadUrlToFile('https://gitlab.com/lon3y/1/-/raw/main/arz-skins.img', 
					getGameDirectory()..'\\modpack\\arz-skins.img', download_handler)
		while not doesFileExist(getGameDirectory()..'\\modpack\\arz-skins.img') do wait(0) end
		dl_files = 8
	end
	if not doesFileExist(getGameDirectory()..'\\modpack\\arz-objects.img') then
		download_id = downloadUrlToFile('https://gitlab.com/lon3y/1/-/raw/main/arz-objects.img', 
					getGameDirectory()..'\\modpack\\arz-objects.img', download_handler)
		while not doesFileExist(getGameDirectory()..'\\modpack\\arz-objects.img') do wait(0) end
		dl_files = 9
	end
	if not doesFileExist(getGameDirectory()..'\\modpack\\arz-tuning.img') then
		download_id = downloadUrlToFile('https://gitlab.com/lon3y/1/-/raw/main/arz-tuning.img', 
					getGameDirectory()..'\\modpack\\arz-tuning.img', download_handler)
		while not doesFileExist(getGameDirectory()..'\\modpack\\arz-tuning.img') do wait(0) end
		dl_files = 10
	end
	if not doesFileExist(getGameDirectory()..'\\_dialogs.asi') then
		download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/arz/_dialogs.asi', 
					getGameDirectory()..'\\_dialogs.asi', download_handler)
		while not doesFileExist(getGameDirectory()..'\\_dialogs.asi') do wait(0) end
		dl_files = 11
	end
	if not doesFileExist(getGameDirectory()..'\\_ci.ini') then
		download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/arz/_ci.ini', 
					getGameDirectory()..'\\_ci.ini', download_handler)
		while not doesFileExist(getGameDirectory()..'\\_ci.ini') do wait(0) end
		dl_files = 12
	end
	if not doesFileExist(getGameDirectory()..'\\_ci.asi') then
		download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/arz/_ci.asi', 
					getGameDirectory()..'\\_ci.asi', download_handler)
		while not doesFileExist(getGameDirectory()..'\\_ci.asi') do wait(0) end
		dl_files = 13
	end
	if not doesFileExist(getGameDirectory()..'\\_chat.asi') then
		download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/arz/_chat.asi', 
					getGameDirectory()..'\\_chat.asi', download_handler)
		while not doesFileExist(getGameDirectory()..'\\_chat.asi') do wait(0) end
		dl_files = 14
	end
	if not doesFileExist(getGameDirectory()..'\\modpack\\arz-vehicles-3.img') then
		download_id = downloadUrlToFile('https://gitlab.com/lon3y/1/-/raw/main/arz-vehicles-3.img', 
					getGameDirectory()..'\\modpack\\arz-vehicles-3.img', download_handler)
		while not doesFileExist(getGameDirectory()..'\\modpack\\arz-vehicles-3.img') do wait(0) end
		dl_files = 15
	end
	if not doesFileExist(getGameDirectory()..'\\modpack\\vcarmods.dat') then
		download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/arz/modpack/carmods.dat', 
					getGameDirectory()..'\\modpack\\carmods.dat', download_handler)
		while not doesFileExist(getGameDirectory()..'\\modpack\\carmods.dat') do wait(0) end
		dl_files = 16
	end
	if not doesFileExist(getGameDirectory()..'\\modpack\\veh_mods.ide') then
		download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/arz/modpack/veh_mods.ide', 
					getGameDirectory()..'\\modpack\\veh_mods.ide', download_handler)
		while not doesFileExist(getGameDirectory()..'\\modpack\\veh_mods.ide') do wait(0) end
		dl_files = 17
	end
	dl_status = true
end

function dlvoice()
	if doesFileExist(getGameDirectory()..'\\bass.dll') and not doesFileExist(getGameDirectory()..'\\bass_1.dll') then
		os.rename(getGameDirectory()..'\\bass.dll', getGameDirectory()..'\\bass_1.dll')
	end

	if not doesFileExist(getGameDirectory()..'\\_AZVoice.asi') then
		download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/arz/azvoice/AZVoice.asi', 
					getGameDirectory()..'\\AZVoice.asi', download_handler)
		while not doesFileExist(getGameDirectory()..'\\AZVoice.asi') do wait(0) end
		dl_files = 1
	end
	if not doesFileExist(getGameDirectory()..'\\bass_fx.dll') then
		download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/arz/azvoice/bass_fx.dll', 
					getGameDirectory()..'\\bass_fx.dll', download_handler)
		while not doesFileExist(getGameDirectory()..'\\bass_fx.dll') do wait(0) end
		dl_files = 2
	end
	if not doesFileExist(getGameDirectory()..'\\bass.dll') then
		download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/arz/azvoice/bass.dll', 
					getGameDirectory()..'\\bass.dll', download_handler)
		while not doesFileExist(getGameDirectory()..'\\bass.dll') do wait(0) end
		dl_files = 3
	end
	if not doesFileExist(getGameDirectory()..'\\bassmix.dll') then
		download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/arz/azvoice/bassmix.dll', 
					getGameDirectory()..'\\bassmix.dll', download_handler)
		while not doesFileExist(getGameDirectory()..'\\bassmix.dll') do wait(0) end
		dl_files = 4
	end
	if not doesFileExist(getGameDirectory()..'\\basswasapi.dll') then
		download_id = downloadUrlToFile('https://github.com/sawyx/mrh/raw/main/arz/azvoice/basswasapi.dll', 
					getGameDirectory()..'\\basswasapi.dll', download_handler)
		while not doesFileExist(getGameDirectory()..'\\basswasapi.dll') do wait(0) end
		dl_files = 5
	end
	dl_status1 = true
end

local open_klad = false
local times_klad = 1
local klad_item = {}

function sp.onServerMessage(color, text) -- текст
	if text:find("h-System%]{......} Выберите призы, которые хотите взять из клада") then
		if not si_thinkbool then
			local intcityklad = getCityPlayerIsIn(PLAYER_PED)
			local cityklad = '. Город не найден.'
			if intcityklad == 0 then cityklad = ' в вне города' end
			if intcityklad == 1 then cityklad = ' в городе Лос Сантос' end
			if intcityklad == 2 then cityklad = ' в городе Сан Фиерро'	end
			if intcityklad == 3 then cityklad = ' в городе Лас Вентурас' end
			tempField = 'cfklad ' .. nick_player.. ' нашел клад' .. cityklad
			ircsend = xpcall(sendchatirc, myerrorhandler)
			tempField = ''
		else
			sampAddChatMessage("[MRH] {A77BCA}Произошла ошибка!", ini.config.clrtext)
		end
		open_klad = true
	end
	if open_klad then
		if text:find("{ffffff}(.+) %[количество: (%d+)%]") then
			print(color)
			kitem, kcount = text:match("{ffffff}(.+) %[количество: (%d+)%]")
			table.insert(klad_item, {kitem, kcount})
			times_klad = times_klad + 1
		end
		if times_klad == 4 then
			table.insert(cfg2.logs.klad, {os.date('%d.%m.%Y | %H:%M:%S'), 
						klad_item[1][1], klad_item[1][2], klad_item[2][1], klad_item[2][2], klad_item[3][1], klad_item[3][2]})
			saveJson(cfg2, jsonDir2)
			open_klad = false
		end
	end
	if gotoeatinhouse and text:find("%[Ошибка%] {FFFFFF}Вы не у своего дома %(1%)!") then
		igvars.autohawk.v = false
		gotoeatinhouse = false
		return false
	end
	if gotoeatinhouse and text:find("%[Ошибка%] {FFFFFF}Вы не возле своего дома") then
		igvars.autohawk.v = false
		gotoeatinhouse = false
		return false
	end
	if gotoeatinhouse and text:find("%[Ошибка%] {FFFFFF}Вы не владелец этого дома!") then
		sampAddChatMessage('[MRH/AutoHawk:Hint] {ffffff}Вы находитесь не дома. Авто-еда выключена.', ini.config.clrtext)
		igvars.autohawk.v = false
		gotoeatinhouse = false
		return false
	end
	if gotoeatinhouse and (text:find("Вам отключили электроэнергию! Оплатите коммуналку!") or text:find("не у своего дома")) then
		--sampAddChatMessage('Отключен', -1)
		gotoeatinhouse = false
	end
	if si_status then
		if text:find("%[VIP%] {FFFFFF}.+%[%d+%]:") or text:find("%[PREMIUM%] {FFFFFF}.+%[%d+%]:") or text:find("%[ADMIN%] {FFFFFF}.+%[%d+%]:") then
			if nick_player == 'Down_Cursed' then
				if not si_thinkbool then
					--si:sendChat(channel_osnova, u8('vipchat '..text))
					tempField = 'vipchat '..text
					ircsend = xpcall(sendchatirc, myerrorhandler)
					tempField = ''
				end
			end
		end
	end
	if text:find ('Вы заглушены. Оставшееся время заглушки') then
		local mutminut, _ = math.modf(tonumber(text:match('заглушки (%d+)')) / 60)
		return {color, string.format("Вы заглушены. Оставшееся время заглушки %s секунд = %s минут(ы)", text:match('заглушки (%d+)'), mutminut)}
	end
	if text:find("Недостаточно VKoin's для приобретения данной периферии") then
		vkcont1 = true
		--sampAddChatMessage('Незя', -1)
	end
	if tr.homejoinbool and text:find("Дверь") then
		return false
	end
	if text:find("(%S+) (%S+) (%S+) (.+) из") and color == -6684673 then
		local kname, kcolorph, kphone = text:match("(%S+) %S+ (%S+) (.+) из")
		--if kname == nick_player then
			if kphone == 'Xiaomi Mi 8' then
				igvars.phoneint.v = 0
				ini.config.phoneint = igvars.phoneint.v
				inicfg.save(cfg, d_ini)
			elseif kphone == 'Huawei P20 PRO' then
				igvars.phoneint.v = 1
				ini.config.phoneint = igvars.phoneint.v
				inicfg.save(cfg, d_ini)
			elseif kphone == 'Google Pixel 3' then
				igvars.phoneint.v = 2
				ini.config.phoneint = igvars.phoneint.v
				inicfg.save(cfg, d_ini)
			end
		--end
	end
	if text:find("Попробуйте переподключиться через (%d+)") then
		temp1 = text:match("Попробуйте переподключиться через (%d+)")
		sampAddChatMessage("[MRH] {ffffff}Включено автоматическое переподключение через {ff6161}"..temp1.."сек.", ini.config.clrtext)
		if igvars.vk_initgame.v and igvars.vknotf.v then
			sendvknotf("\nПереподключение через: ".. temp1 .." сек.")
		end
		recarz:run()
	end
	if igvars.chat_trash.v then
		if text:find("Подробней об контрабанде: {EA5C5C}'/smug'") then
			return false
		end
		if text:find("Быстрее отправляйтесь на его разгрузку, чтобы его не забрали другие!") and not text:find('говорит') then
			return false
		end
		if text:find("Ваши друзья из {EA5C5C}Либерти Сити{FFFFFF}, сбросили для вас контейнер контрабанды!") then
			return false
		end
		if text:find("~~~~~~~~~~~~~~~~~~~~~~~~~~") and not text:find('говорит') then
			return false
		end
		if text:find("- Основные команды") and not text:find('говорит') then
			return false
		end
		if text:find("- Пригласи друга") and not text:find('говорит') then
			return false
		end
		if text:find("- Донат и получение") and not text:find('говорит') then
			return false
		end
		if text:find("выехал") and not text:find('говорит') then
			return false
		end
		if text:find("убив его") and not text:find('говорит') then
			return false
		end
		if text:find("начал работу") and not text:find('говорит') then
			return false
		end
		if text:find("Убив его") and not text:find('говорит') then
			return false
		end
		if text:find("между использованием") and not text:find('говорит') then
			return false
		end
		if text:find("обновлениях сервера") and not text:find('говорит') then
			return false
		end
		if text:find("Пополнение игрового счета") and not text:find('говорит') then
			return false
		end
		if text:find("Наш сайт") and not text:find('говорит') then
			return false
		end
		if text:find("На сервере есть инвентарь, используйте клавишу Y для работы с ним.") and not text:find('говорит') then
			return false
		end
		if text:find("Вы можете задать вопрос в нашу техническую поддержку /report.") and not text:find('говорит') then
			return false
		end
		if text:find("В нашем магазине ты можешь приобрести нужное количество игровых денег") and not text:find('говорит') then
			return false
		end
		if text:find("их на желаемый тобой {FFFFFF}бизнес, дом, аксессуар") then
			return false
		end
		if text:find("подробнее /help %[Преимущества VIP%]") and not text:find('говорит') then
			return false
		end
		if text:find("магазине так-же можно приобрести") and not text:find('говорит') then
			return false
		end
		if text:find("автомобили, аксессуары, воздушные шары") and not text:find('говорит') then
			return false
		end
		if text:find("которые выделят тебя из толпы! Наш сайт:") and not text:find('говорит') then
			return false
		end
		if text:find("Чтобы запустить браузер используйте клавишу") and not text:find('говорит') then
			return false
		end
		if text:find("для того, чтобы показать курсор управления или") and not text:find('говорит') then
			return false
		end
		if text:find("Полицейский участок") and text:find("911 - ") and not text:find('говорит') then
			return false
		end
		if text:find("Скорая помощь") and text:find("912 - ") and not text:find('говорит') then
			return false
		end
		if text:find("Такси") and text:find("913 - ") and not text:find('говорит') then
			return false
		end
		if text:find("Механик") and text:find("914 -") and not text:find('говорит') then
			return false
		end
		if text:find("Проверить баланс телефона") and text:find("111 -") and not text:find('говорит') then
			return false
		end
		if text:find("Служба точного времени") and text:find("060 -") and not text:find('говорит') then
			return false
		end
		if text:find("Справочная центрального банка") and text:find("8828 -") and not text:find('говорит') then
			return false
		end
		if text:find("по вопросам жилой недвижимости") and text:find("997 -") and not text:find('говорит') then
			return false
		end
		if text:find("Номера телефонов государственных служб:") and not text:find('говорит') then
			return false
		end
		if text:find("С помощью телефона можно заказать такси. Среднее время ожидания") and not text:find('говорит') then
			return false
		end 
		if text:find("Купить баллончик, можно в магазине механики. Посмотреть карту граффити, можно в общаке!") and not text:find('говорит') then
			return false
		end 
		if text:find("4-я домами могут бесплатно раз в день получать \"2 Ларца Олигарха\" в банке и его отделениях.") and not text:find('говорит') then
			return false
		end 
		if text:find('News') and not text:find('говорит') and not text:find('- |') and not text:find('Тел.') then 
			return false 
		end
	end
	if igvars.vknotf.v then
		if tr.ruletka and text:find("Вы использовали сундук с рулетками и получили (.+)!") then
			sendvknotf("\n".. text)
			tr.ruletka = false
		end
		if igvars.vk_initgame.v then
			if text:find("На сервере есть инвентарь, используйте клавишу Y для работы") then
				sendvknotf('\nВы подключились к серверу!')
			end
		end
		if igvars.vk_payday.v then
			if text:find('Банковский чек') and color == 1941201407 then
				ispaydaystate = true
				ispaydaytext = ''
			end
			if ispaydaystate then
				if text:find('Депозит в банке') then 
					ispaydaytext = ispaydaytext..'\n___ PayDay ___\n'..text
				elseif text:find('Сумма к выплате') then
					ispaydaytext = ispaydaytext..'\n'..text
				elseif text:find('Текущая сумма в банке') then
					ispaydaytext = ispaydaytext..'\n'..text
				elseif text:find('Текущая сумма на депозите') then
					ispaydaytext = ispaydaytext..'\n'..text
					sendvknotf(ispaydaytext)
					ispaydaystate = false
					ispaydaytext = ''
				end
			end
			if text:find('Вы достигли') then 
				sendvknotf(text)
			end
		end
		if igvars.vk_listen.v then
			if not text:find('News') and not text:find('СМИ') and not text:find('Объявление:') then
				sendvknotf('\n'..text)
			end
		end
	end
	if text:find('Администратор (.+) посадил игрока (.+) в деморган на (.+) минут. Причина:') then
		demorgan = text:match("Администратор .+ посадил игрока (.+) в деморган на .+ минут. Причина:")
		t_player_id = nick_player..'['..id..']'
		if demorgan == t_player_id then
			if igvars.klad.v then
				igvars.changescr.v = true
				igvars.klad.v = false
				inicfg.save(cfg, d_ini)
			end
		end
	end
	if igvars.antilomka.v and text:find('У вас началась сильная ломка') or text:find('Вашему персонажу нужно принять') then 
		return false 
	end
end

function download_handler(id, status, p1, p2)
	if stop_downloading then
	  	stop_downloading = false
	  	download_id = nil
	  	print('Загрузка отменена.')
	  	return false -- прервать загрузку
	end
	if status == dlstatus.STATUS_DOWNLOADINGDATA then
	  	--print(string.format('Загружено %d из %d.', p1, p2))
		pp1, pp2 = p1, p2
	elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
	  	print('Загрузка завершена.')
	end
end

local edittimebool = false

function edittime()
	igvars.main_window_state.v = false
	edittimebool = true
	wait(50)
	showCursor(true)
	sampAddChatMessage('[MRH/GUI:Hint] {ffffff}Нажмите {bfabfa}ПКМ {ffffff}что бы сохранить позицию времени', ini.config.clrtext)
	while edittimebool do
		igvars.timeX.v, igvars.timeY.v = getCursorPos()
		if isKeyDown(0x02) then
			igvars.main_window_state.v = true
			edittimebool = false
			showCursor(false)
			ini.config.timeX = igvars.timeX.v
			ini.config.timeY = igvars.timeY.v
			inicfg.save(cfg, d_ini)
		end
		wait(0)
	end
end

local vkcont = false
function vkoinfunc()
	while true do
		for i = 1, 7, 1 do
			if buy[i].v and vkcont then
				local d = i-1
				--sampAddChatMessage(tostring(vkcont), -1)
				--sampSendDialogResponse(ids['dialogBoost'], 1, d, -1)

				if sampGetCurrentDialogId() == 25012 then 
					sampSendDialogResponse(ids['dialogBoost'], 1, d, -1) 
				end

				if sampGetCurrentDialogId() == 25013 then 
					sampCloseCurrentDialogWithButton(1)
				end
			end
		end
		wait(0)
	end
end

function sp.onSendChat(msg)
	if msg:find('{select_id}') then
		if actionId ~= nil then
			msg = msg:gsub('{select_id}', actionId)
			return { msg }
		end
		sampAddChatMessage('[MRH/Binder] {ffffff}Вы ещё не отметили игрока для тега {select_id}', ini.config.clrtext)
		return false
	end

	if msg:find('{select_name}') then
		local result, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
		if result then
			local res, actionId = sampGetPlayerIdByCharHandle(ped)
			if actionId ~= nil then
				msg = msg:gsub('{select_name}', nonRpNick(actionId))
				return { msg }
			end
		end
		sampAddChatMessage('[MRH/Binder] {ffffff}Вы ещё не отметили игрока для тега {select_name}', ini.config.clrtext)
		return false
	end

	if msg:find('{select_rp_name}') then
		local result, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
		if result then
			local res, actionId = sampGetPlayerIdByCharHandle(ped)
			if actionId ~= nil then
				msg = msg:gsub('{select_rp_name}', rpNick(actionId))
				return { msg }
			end
		end
		sampAddChatMessage('[MRH/Binder] {ffffff}Вы ещё не отметили игрока для тега {select_rp_name}', ini.config.clrtext)
		return false
	end

	if msg:find('{my_id}') then
		local id = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
		msg = msg:gsub('{my_id}', tostring(id))
		return { msg }
	end

	if msg:find('{my_name}') then
		local id = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
		msg = msg:gsub('{my_name}', nonRpNick(id))
		return { msg }
	end

	if msg:find('{my_rp_name}') then
		local id = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
		msg = msg:gsub('{my_rp_name}', rpNick(id))
		return { msg }
	end

	if msg:find('{nearest_id}') then
		local result, id = getClosestPlayerId()
		if result then
			msg = msg:gsub('{nearest_id}', tostring(id))
			return { msg }
		end
		sampAddChatMessage('[MRH/Binder] {ffffff}В вашем радиусе нет игроков для применения тега {nearest_id}', ini.config.clrtext)
		return false
	end

	if msg:find('{nearest_name}') then
		local result, id = getClosestPlayerId()
		if result then
			msg = msg:gsub('{nearest_name}', nonRpNick(id))
			return { msg }
		end
		sampAddChatMessage('[MRH/Binder] {ffffff}В вашем радиусе нет игроков для применения тега {nearest_name}', ini.config.clrtext)
		return false
	end

	if msg:find('{nearest_rp_name}') then
		local result, id = getClosestPlayerId()
		if result then
			msg = msg:gsub('{nearest_rp_name}', rpNick(id))
			return { msg }
		end
		sampAddChatMessage('[MRH/Binder] {ffffff}В вашем радиусе нет игроков для применения тега {nearest_rp_name}', ini.config.clrtext)
		return false
	end

	if msg:find('{time}') then
		msg = msg:gsub('{time}', os.date("%H:%M", os.time()))
		return { msg }
	end

	if msg:find('{time_s}') then
		msg = msg:gsub('{time_s}', os.date("%H:%M:%S", os.time()))
		return { msg }
	end

	if msg:find('{screen}') then
		sampSendChat('/time')
		msg = msg:gsub('{screen}', '')
		return #msg > 0 and { msg } or false
	end
end

function inputChat()
	while true do
		if igvars.tcmd.v then
			if(sampIsChatInputActive())then
				local getInput = sampGetChatInputText()
				if(oldText ~= getInput and #getInput > 0)then
					local firstChar = string.sub(getInput, 1, 1)
					if(firstChar == "." or firstChar == "/")then
						local cmd, text = string.match(getInput, "^([^ ]+)(.*)")
						local nText = "/" .. translite(string.sub(cmd, 2)) .. text
						local chatInfoPtr = sampGetInputInfoPtr()
						local chatBoxInfo = getStructElement(chatInfoPtr, 0x8, 4)
						local lastPos = memory.getint8(chatBoxInfo + 0x11E)
						sampSetChatInputText(nText)
						memory.setint8(chatBoxInfo + 0x11E, lastPos)
						memory.setint8(chatBoxInfo + 0x119, lastPos)
						oldText = nText
					end
				end
			end
		end
		wait(0)
	end
end

function auto_bike(id)
	while not sampTextdrawIsExists(id) do wait(0) end
	while sampTextdrawIsExists(id) do
		setGameKeyState(9, 255)
		setGameKeyState(16, 255)
		setGameKeyState(21, 255)
		wait(1)
		setGameKeyState(9, 0)
		wait(1)
		setGameKeyState(16, 0)
		wait(1)
		setGameKeyState(21, 0)
	end
	bool_bike = false
end

function translite(text)
	for k, v in pairs(chars) do
		text = string.gsub(text, k, v)
	end
	return text
end

function time()
	startTime = os.time()                                               -- "Точка отсчёта"
    connectingTime = 0
    while true do
        wait(1000)
        nowTime = os.date("%H:%M:%S", os.time())
        if sampGetGamestate() == 3 then 								-- Игровой статус равен "Подключён к серверу" (Что бы онлайн считало только, когда, мы подключены к серверу)
	        sesOnline.v = sesOnline.v + 1 								-- Онлайн за сессию без учёта АФК
	        sesFull.v = os.time() - startTime 							-- Общий онлайн за сессию
	        sesAfk.v = sesFull.v - sesOnline.v							-- АФК за сессию

	        cfg.onDay.online = cfg.onDay.online + 1 					-- Онлайн за день без учёта АФК
	        cfg.onDay.full = dayFull.v + sesFull.v 						-- Общий онлайн за день
	        cfg.onDay.afk = cfg.onDay.full - cfg.onDay.online			-- АФК за день

	        cfg.onWeek.online = cfg.onWeek.online + 1 					-- Онлайн за неделю без учёта АФК
	        cfg.onWeek.full = weekFull.v + sesFull.v 					-- Общий онлайн за неделю
	        cfg.onWeek.afk = cfg.onWeek.full - cfg.onWeek.online		-- АФК за неделю

            local today = tonumber(os.date('%w', os.time()))
            cfg.myWeekOnline[today] = cfg.onDay.full

            connectingTime = 0
	    else
            connectingTime = connectingTime + 1                         -- Вермя подключения к серверу
	    	startTime = startTime + 1									-- Смещение начала отсчета таймеров
	    end
    end
end

function autoSave()
	while true do 
		wait(60000) -- сохранение каждые 60 секунд
		inicfg.save(cfg, d_ini)
	end
end

local fsClock = nil
local fa_font = nil
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })
font = {}
function imgui.BeforeDrawFrame()

	local font_config = imgui.ImFontConfig()
    font_config.MergeMode = true
	if fa_font == nil then
        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 13.0, font_config, fa_glyph_ranges)
    end
	if tr.image == nil then
		tr.image = imgui.CreateTextureFromFile("moonloader/resource/img/teminator.png")
	end
    local range = {
    	text = imgui.GetIO().Fonts:GetGlyphRangesCyrillic(),
    	icon = imgui.ImGlyphRanges({ 0xf000, 0xf83e })
    }
    
	for _, size in ipairs({ 13, 14, 15, 20, 24, 35, 45, 60 }) do
		if font[size] == nil then 
			font[size] = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', size, nil, range.text) 
		end
	end
	if fsClock == nil then
        fsClock = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 25.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
    end
end

function imgui.OnDrawFrame() -- IMGUI
	if igvars.tsr_informer.v then
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(200, 200), imgui.Cond.FirstUseEver)
		imgui.Begin("Tsr info", igvars.tsr_informer, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
		imgui.Text(u8("Ящики: "..tsrbox..' '))
		imgui.End()
	end
	if igvars.window_vkoin.v then
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 1.2 , sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(250, 280), imgui.Cond.FirstUseEver)
		imgui.Begin("VKoin bot", igvars.window_vkoin, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
			imgui.Text(u8("В секунду: "..vkoinsev))
			if getbalance() then balance = getbalance() else balance = "Телефон закрыт" end
			imgui.Text(u8('Баланс: '..balance))
			imgui.NewLine()
			imgui.Text(u8'Тип покупки:')
			imgui.BeginChild('buylist', imgui.ImVec2(180, 180), true)
				imgui.Text(u8'Клик мыши') imgui.SameLine(150) imgui.Checkbox('##1', buy[1])
				imgui.Text(u8 "Видеокарта") imgui.SameLine(150) imgui.Checkbox('##2', buy[2])
				imgui.Text(u8 "Стойка видеокарт") imgui.SameLine(150) imgui.Checkbox('##3', buy[3])
				imgui.Text(u8 "Суперкомпьютер") imgui.SameLine(150) imgui.Checkbox('##4', buy[4])
				imgui.Text(u8 "Сервер Arizona Games") imgui.SameLine(150) imgui.Checkbox('##5', buy[5])
				imgui.Text(u8 "Квантовый компьютер") imgui.SameLine(150) imgui.Checkbox('##6', buy[6])
				imgui.Text(u8 "Датацентр") imgui.SameLine(150) imgui.Checkbox('##7', buy[7])
			imgui.EndChild()
			imgui.SameLine()
			if imgui.Button(u8 "Начать") then
				vkcont = not vkcont
			end
			if imgui.Button(u8 "12") then
				vkcont = false
			end
		imgui.End()
	end
	if igvars.window_calc.v and sampIsChatInputActive() then
        local input = sampGetInputInfoPtr()
        local input = getStructElement(input, 0x8, 4)
        local windowPosX = getStructElement(input, 0x8, 4)
        local windowPosY = getStructElement(input, 0xC, 4)
        imgui.SetNextWindowPos(imgui.ImVec2(windowPosX, windowPosY + 30 + 15), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowSize(imgui.ImVec2(resultcal:len()*8, 30))
        imgui.Begin('Solve', igvars.window_calc, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
        imgui.CenterText(u8(resultcal))
        imgui.End()
    end
	if igvars.new_report.v then
        dialog_size_x = 400
        dialog_size_y = 175
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2 - dialog_size_x / 2, sh / 2 - dialog_size_y / 2), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowSize(imgui.ImVec2(dialog_size_x, dialog_size_y), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Репорт##new_report', igvars.new_report, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
			imgui.Text(u8'Написать репорт:')
			imgui.PushItemWidth(385)
			if focus then
				imgui.SetKeyboardFocusHere(0)
				focus = false
			end
			local saverep = imgui.InputText("inprep##input_report", igvars.input_report, imgui.InputTextFlags.EnterReturnsTrue)
			imgui.PopItemWidth()
			imgui.Separator()
			if imgui.RadioButton(u8'Не сохранять репорт', igvars.save_report,1) then
				sampAddChatMessage('[MRH] {ffffff}В разработке..', ini.config.clrtext)
			end
			imgui.SameLine()
			if imgui.RadioButton(u8'Сохранить репорт', igvars.save_report,2) then
				sampAddChatMessage('[MRH] {ffffff}В разработке..',ini.config.clrtext)
			end
			imgui.Separator()
			imgui.Text(u8'Быстрый репорт:')
			if imgui.AnimatedButton(u8('Помогите'), imgui.ImVec2(125,21)) then
				sampSendDialogResponse(32, 1, _, "Помогите")
				igvars.new_report.v = false
			end
			imgui.SameLine()
			if imgui.AnimatedButton(u8('Достать велик'), imgui.ImVec2(125,21)) then
				sampSendDialogResponse(32, 1, _, "Помогите достать велик")
				igvars.new_report.v = false
			end
			imgui.SameLine()
			if imgui.AnimatedButton(u8('Пусто :)'), imgui.ImVec2(125,21)) then
				sampSendDialogResponse(32, 0, _, "")
				igvars.new_report.v = false
			end
			imgui.Separator()
			if imgui.CustomButton(u8'Закрыть', imgui.ImVec4(0.2,0.2,0.3,1), imgui.ImVec4(0.2,0.2,0.3,0.8), imgui.ImVec4(0.2,0.2,0.3,0.6), imgui.ImVec2(125,21)) then
				sampSendDialogResponse(32, 0, _, "")
				igvars.new_report.v = false
			end
			imgui.SameLine(268)
			if imgui.CustomButton(u8'Отправить', imgui.ImVec4(0.2,0.2,0.3,1), imgui.ImVec4(0.2,0.2,0.3,0.8), imgui.ImVec4(0.2,0.2,0.3,0.6), imgui.ImVec2(125,21)) then
				sampSendDialogResponse(32, 1, _, u8:decode(igvars.input_report.v))
				igvars.input_report.v = ""
				igvars.new_report.v = false
			end
			if saverep then
				sampSendDialogResponse(32, 1, _, u8:decode(igvars.input_report.v))
				igvars.input_report.v = ""
				igvars.new_report.v = false
			end
        imgui.End()
    end
	if igvars.main_window_state.v then
        imgui.SetNextWindowSize(imgui.ImVec2(750, 400), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin('##window', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
				imgui.PushFont(font[20])
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(ini.config.FrameBg1, ini.config.FrameBg2, ini.config.FrameBg3, 1.00))
			imgui.Text(u8'MultiRecHelper')
				imgui.PopStyleColor(1)
				imgui.SetCursorPos(imgui.ImVec2(635, 7))
				imgui.Text(os.date(u8'%H:%M:%S', os.time()))
				imgui.PopFont()
				imgui.SetCursorPos(imgui.ImVec2(157, 5))
				imgui.PushFont(font[24])
			if tab.v == 0 then
				imgui.Text(tabs2[1])
			else
				imgui.Text(tabs2[tab.v + 1])
			end
				imgui.PopFont()
				imgui.SetCursorPos(imgui.ImVec2(721, 10))
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(1.00, 1.00, 1.00, 0.00))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1.00, 1.00, 1.00, 0.00))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(1.00, 1.00, 1.00, 0.00))
				imgui.PushStyleVar(imgui.StyleVar.FrameRounding, 16)
			if imgui.Button('', imgui.ImVec2(16,16)) then
				igvars.main_window_state.v = false
			end
				imgui.SetCursorPos(imgui.ImVec2(723, 11))
			imgui.Text(fa.ICON_FA_TIMES_CIRCLE)
				imgui.PopStyleVar(1)
					imgui.PopStyleColor(3)
				imgui.SetCursorPos(imgui.ImVec2(27, 380))
				imgui.PushFont(font[14])
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(ini.config.FrameBg1, ini.config.FrameBg2, ini.config.FrameBg3, 1.00))
			imgui.Text('by Kalg0n   '.. 'v.'.. scr_vers_text )
				imgui.PopStyleColor(1)
				imgui.PopFont()
				
				imgui.SetCursorPos(imgui.ImVec2(0, 45))
            if imgui.CustomMenu(tabs, tab, imgui.ImVec2(135, 30), _, true) then
                --sampAddChatMessage('Вы нажали на элемент №'..tab.v)
            end
				imgui.PushStyleVar(imgui.StyleVar.FrameRounding, 4)
				imgui.SetCursorPos(imgui.ImVec2(5, 355))
			if not upd_state then
				if imgui.ButtonClickable(tr.clickupd, u8"Проверить обновление",imgui.ImVec2(142,20), 0.5, true) then
					clickupdwait()

					asyncHttpRequest('GET', 'https://raw.githubusercontent.com/sawyx/mrh/main/updmrh.json', {headers={["user-agent"] = "Mozilla/5.0"}},
					function (result)
						if result then
							aupd = decodeJson(result.text)
							if tonumber(aupd["vers"]) > scr_vers then
								sampAddChatMessage("[MRH/Update] {ffffff}Найдено новое обновление скрипта: {DF4848}" .. aupd["vers_text"], ini.config.clrtext)
								upd_state = true
							else
								sampAddChatMessage("[MRH/Update] {ffffff}У вас установлена последняя версия скрипта: {DF4848}" .. aupd["vers_text"], ini.config.clrtext)
							end
						end
					end)
				end
				--imgui.SetCursorPos(imgui.ImVec2(5, 330))
			elseif upd_state then
				if imgui.AnimatedButton(fa.ICON_FA_DOWNLOAD,imgui.ImVec2(20,20), 1.0, true) then
					igvars.main_window_state.v = false
					upd_state2 = true
					downloadUrlToFile(scr_url, scr_path, function(id, status)
						if status == dlstatus.STATUS_ENDDOWNLOADDATA then
							sampAddChatMessage("[MRH/Update] {ffffff}Обновление успешно загружено.", ini.config.clrtext)
							tr.reloadR = true
							thisScript():reload()
						end
					end)
				end
			end
			imgui.PopStyleVar()
            imgui.SetCursorPos(imgui.ImVec2(150, 35))
            imgui.BeginChild('##main', imgui.ImVec2(600, 370), true)

				if tab.v == 0 then
					local hour = tonumber(os.date("%H"))
						imgui.PushFont(font[24])
					if hour >= 5 and hour <= 10 then imgui.CenterText(string.format(u8"Доброе утро, %s!", nick_player)) end
					if hour >= 11 and hour <= 16 then imgui.CenterText(string.format(u8"Добрый день, %s!", nick_player)) end
					if hour >= 17 and hour <= 22 then imgui.CenterText(string.format(u8"Добрый вечер, %s!", nick_player)) end
					if hour >= 23 or hour <= 4 then imgui.CenterText(string.format(u8"Доброй ночи, %s!", nick_player)) end
					imgui.PopFont()
					imgui.Image(tr.image, imgui.ImVec2(imgui.GetWindowWidth(), imgui.GetWindowHeight()/1.125))
				elseif tab.v == 1 then
					if imgui.Checkbox(u8"Быстрый бег [W+1]##max_speedped", igvars.max_speedped) then
						ini.config.max_speedped = igvars.max_speedped.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(150)
					if imgui.Checkbox(u8"Достать телефон [P]##phone", igvars.phone) then
						ini.config.phone = igvars.phone.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(300)
					if imgui.Checkbox(u8"Закрытие р. т/с [JL]##jlock_c", igvars.jlock_car) then
						ini.config.jlock_car = igvars.jlock_car.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(450)
					if imgui.Checkbox(u8"Авто стрелки [SHIFT]##max_speed", igvars.max_speed) then
						ini.config.max_speed = igvars.max_speed.v
						inicfg.save(cfg, d_ini)
					end

					if imgui.Checkbox(u8"КамХак [C+1 / C+2]##chack", igvars.chack) then
						ini.config.chack = igvars.chack.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(150)
					if imgui.Checkbox(u8"Закрытие т/c [L]##lock_c", igvars.lock_c) then
						ini.config.lock_car = igvars.lock_c.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(300)
					if imgui.Checkbox(u8"Закрытие о. т/c [OL]##olock_c", igvars.olock_c) then
						ini.config.olock_car = igvars.olock_c.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(450)
					if imgui.Checkbox(u8"Ключи от т/c [K]##key_c", igvars.key_c) then
						ini.config.key_c = igvars.key_c.v
						inicfg.save(cfg, d_ini)
					end

					if imgui.Checkbox(u8"Вход в дом [ALT]##home_l", igvars.home_l) then
						ini.config.home_lock = igvars.home_l.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(150)
					if imgui.Checkbox(u8"Калькулятор##calc", igvars.calc) then
						ini.config.calc = igvars.calc.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(300)
					if imgui.Checkbox(u8"Очистка чата##chat_trash", igvars.chat_trash) then
						ini.config.chat_trash = igvars.chat_trash.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(450)
					if imgui.Checkbox(u8"Очистка диалогов##dialog_trash", igvars.dialog_trash) then
						ini.config.dialog_trash = igvars.dialog_trash.v
						inicfg.save(cfg, d_ini)
					end

					if imgui.Checkbox(u8"Анти ломка##antilomka", igvars.antilomka) then
						ini.config.antilomka = igvars.antilomka.v
						inicfg.save(cfg, d_ini)
					end 
					imgui.SameLine(150)
					if imgui.Checkbox(u8"Анти банихоп##bhop", igvars.bhop) then
						ini.config.bhop = igvars.bhop.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(300)
					if imgui.Checkbox(u8"Бесконечеый бег##infrun", igvars.infrun) then
						irun()
						ini.config.infrun = igvars.infrun.v
						inicfg.save(cfg, d_ini)
					end 
					imgui.SameLine(450)
					if imgui.Checkbox(u8"Перевод команд##tcmd", igvars.tcmd) then
						ini.config.tcmd = igvars.tcmd.v
						inicfg.save(cfg, d_ini)
					end

					if imgui.Checkbox(u8"Рекон в рестарт##rec_r", igvars.rec_r) then
						ini.config.rec_restart = igvars.rec_r.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(150)
					if imgui.Checkbox(u8"Авто пин-код##auto_p", igvars.auto_p) then
						ini.config.auto_pincod = igvars.auto_p.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(300)
					if imgui.Checkbox(u8"Авто логин##auto_l", igvars.auto_l) then
						ini.config.auto_login = igvars.auto_l.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(450)
					if imgui.Checkbox(u8"Эмулятор лаунчера##arz_laun", igvars.arz_laun) then
						ini.config.arzlaun = igvars.arz_laun.v
						inicfg.save(cfg, d_ini)
						if igvars.arz_laun.v then
							sampAddChatMessage("[MRH] {ffffff}Для работы эмулятора, {FF4848}ПЕРЕЗАЙДИТЕ '//rec'.", ini.config.clrtext)
							--sampAddChatMessage("[MRH] {ffffff}Для работы эмулятора, {FF4848}ПЕРЕЗАЙДИТЕ '//rec'.", ini.config.clrtext)
						end
					end
					
					if imgui.Checkbox(u8"Анти-афк##aafk", igvars.aafk) then
						a_afk()
						ini.config.a_afk = igvars.aafk.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(150)
					if imgui.Checkbox(u8"Запомнить диалоги##savedialog", igvars.savedialog) then
						ini.config.savedialog = igvars.savedialog.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(300)
					if imgui.Checkbox(u8"Клады в чат##klad", igvars.klad) then
						ini.config.klad_find = igvars.klad.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(450)
					if imgui.Checkbox(u8"Ответы на клады##answer_k", igvars.answer_k) then
						ini.config.answer_k = igvars.answer_k.v
						inicfg.save(cfg, d_ini)
					end

					if imgui.Checkbox(u8"Убрать кусты##kystibool", igvars.kystibool) then
						ini.config.kystibool = igvars.kystibool.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(150)
					if imgui.Checkbox(u8"Время##timedraw", igvars.timedraw) then
						ini.config.timedraw = igvars.timedraw.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(300)
					if imgui.Checkbox(u8"Вип чат##vipchat", igvars.vipchat) then
						ini.config.vipchat = igvars.vipchat.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(450)
					if imgui.Checkbox(u8"Удаление игроков##fpscr", igvars.fpscr) then
						DEL_PLAYER = not DEL_PLAYER
						for _, handle in ipairs(getAllChars()) do
							if doesCharExist(handle) then
								local _, id = sampGetPlayerIdByCharHandle(handle)
								if id ~= myid then
									emul_rpc('onPlayerStreamOut', { id })
									npc[#npc + 1] = id
								end
							end
						end
						
						if not igvars.fpscr.v then
							for i = 1, #npc do
								send_player_stream(npc[i], infnpc[npc[i]])
								npc[i] = nil
							end
						end
					end
					
					if imgui.Checkbox(u8"Авто Еда##autohawk", igvars.autohawk) then
						ini.config.autohawk = igvars.autohawk.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(150)
					if imgui.Checkbox(u8"Биндер##binder", igvars.binder) then
						ini.config.binder = igvars.binder.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(300)
					if imgui.Checkbox(u8"Авто сундуки##autochest", igvars.autochest) then
						ini.config.autochest = igvars.autochest.v
						inicfg.save(cfg, d_ini)
					end
					imgui.SameLine(450)
					if imgui.Checkbox(u8"Удаление машин##removecar", igvars.removecar) then
						hidecars()
						ini.config.removecar = igvars.removecar.v
						inicfg.save(cfg, d_ini)
					end

					if imgui.Checkbox(u8"Авто сбор велика##autobike", igvars.autobike) then
						ini.config.autobike = igvars.autobike.v
						inicfg.save(cfg, d_ini)
					end
                elseif tab.v == 2 then
					imgui.SetCursorPos(imgui.ImVec2(70,6))
					for i, title in ipairs(navigation.list) do
						if HeaderButton(navigation.current == i, title) then
							navigation.current = i
						end
						if i ~= #navigation.list then
							imgui.SameLine(nil, 35)
						end
					end
					imgui.SetCursorPos(imgui.ImVec2(-1, 27))
					imgui.Separator()
					imgui.SetCursorPos(imgui.ImVec2(8, 40))
					if navigation.current == 1 then
						--imgui.NewLine()
						--imgui.PushItemWidth(136)
						if imgui.ColorEdit4(u8'Цвет кнопок', FrameBg, imgui.ColorEditFlags.NoInputs) then
							ini.config.FrameBg1, ini.config.FrameBg2, ini.config.FrameBg3, ini.config.FrameBg4 = FrameBg.v[1], FrameBg.v[2], FrameBg.v[3], FrameBg.v[4]
							inicfg.save(cfg, d_ini)
							apply_custom_style()
						end
						if imgui.ColorEdit4(u8'Цвет заголовка', TitleBg, imgui.ColorEditFlags.NoInputs) then
							ini.config.TitleBg1, ini.config.TitleBg2, ini.config.TitleBg3, ini.config.TitleBg4 = TitleBg.v[1], TitleBg.v[2], TitleBg.v[3], TitleBg.v[4]
							inicfg.save(cfg, d_ini)
							apply_custom_style()
						end
						if imgui.ColorEdit4(u8'Цвет текста', textClr, imgui.ColorEditFlags.NoInputs) then
							ini.config.textClr1, ini.config.textClr2, ini.config.textClr3, ini.config.textClr4 = textClr.v[1], textClr.v[2], textClr.v[3], textClr.v[4]
							inicfg.save(cfg, d_ini)
							apply_custom_style()
						end
						if imgui.ColorEdit4(u8'Цвет фона', WindowBg, imgui.ColorEditFlags.NoInputs) then
							ini.config.WindowBg1, ini.config.WindowBg2, ini.config.WindowBg3, ini.config.WindowBg4 = WindowBg.v[1], WindowBg.v[2], WindowBg.v[3], WindowBg.v[4]
							inicfg.save(cfg, d_ini)
							apply_custom_style()
						end
						if imgui.AnimatedButton(u8"Сбросить##ccleanall",imgui.ImVec2(70,20)) then
							WindowBg = imgui.ImFloat4(0.11, 0.10, 0.11, 1.00)
							textClr = imgui.ImFloat4(1.00, 1.00, 1.00, 1.00)
							TitleBg = imgui.ImFloat4(0.00, 0.46, 0.65, 1.00)
							FrameBg = imgui.ImFloat4(0.21, 0.20, 0.21, 0.60)
							apply_custom_style()
						end
						imgui.SameLine()
						if imgui.AnimatedButton(u8"Сохранить##csaveall",imgui.ImVec2(70,20)) then
							ini.config.FrameBg1, ini.config.FrameBg2, ini.config.FrameBg3, ini.config.FrameBg4 = FrameBg.v[1], FrameBg.v[2], FrameBg.v[3], FrameBg.v[4]
							ini.config.TitleBg1, ini.config.TitleBg2, ini.config.TitleBg3, ini.config.TitleBg4 = TitleBg.v[1], TitleBg.v[2], TitleBg.v[3], TitleBg.v[4]
							ini.config.textClr1, ini.config.textClr2, ini.config.textClr3, ini.config.textClr4 = textClr.v[1], textClr.v[2], textClr.v[3], textClr.v[4]
							ini.config.WindowBg1, ini.config.WindowBg2, ini.config.WindowBg3, ini.config.WindowBg4 = WindowBg.v[1], WindowBg.v[2], WindowBg.v[3], WindowBg.v[4]
							inicfg.save(cfg, d_ini)
							apply_custom_style()
						end	
						imgui.NewLine()
						imgui.Text(u8('Время:'))
						imgui.PushItemWidth(150)
						if imgui.Combo(u8'Шрифт', igvars.timeFont, {'Courier New', 'Arial', 'Arial Black', 'Franklin Gothic Medium', 'Impact'}, 5) then
							fontUpdate(igvars.timeFont.v)
							ini.config.timeFont = igvars.timeFont.v
							inicfg.save(cfg, d_ini)
						end
						if imgui.SliderInt(u8"Размер##timeHeight", igvars.timeHeight, 10, 100) then
							fontUpdate()
							ini.config.timeHeight = igvars.timeHeight.v
							inicfg.save(cfg, d_ini)
						end
						if imgui.SliderInt(u8"Стиль##timeVar", igvars.timeVar, 0, 15) then
							fontUpdate()
							ini.config.timeVar = igvars.timeVar.v
							inicfg.save(cfg, d_ini)
						end
						imgui.PopItemWidth()
						if imgui.AnimatedButton(u8"Переместить",imgui.ImVec2(90,20)) then
							lua_thread.create(edittime)
						end
						if imgui.ColorEdit3(u8'Цвет времени', colortime, imgui.ColorEditFlags.NoInputs) then
							local clrtime = join_argb(0, colortime.v[1] * 255, colortime.v[2] * 255, colortime.v[3] * 255)
							igvars.colort.v = "{"..('%06X'):format(clrtime).."}"
							ini.config.colort = igvars.colort.v
							ini.config.colortime1, ini.config.colortime2, ini.config.colortime3 = colortime.v[1], colortime.v[2], colortime.v[3]
							inicfg.save(cfg, d_ini)
						end
						imgui.NewLine()
						if imgui.ColorEdit3(u8'Цвет текста скрипта##colortext', colortext, imgui.ColorEditFlags.NoInputs) then
							local clrtext = join_argb(0, colortext.v[1] * 255, colortext.v[2] * 255, colortext.v[3] * 255)
							ini.config.clrtext = clrtext
							ini.config.colortext1, ini.config.colortext2, ini.config.colortext3 = colortext.v[1], colortext.v[2], colortext.v[3]
							inicfg.save(cfg, d_ini)
						end
					elseif navigation.current == 2 then -- Авто АФК
						--imgui.NewLine()
						imgui.Text(u8'Авто Еда:')
						if not igvars.autohawk.v then
							imgui.PushFont(font[20])
							imgui.CenterText(u8'Авто Еда выключена')
							imgui.PopFont()
						else
							if imgui.ToggleButton(u8"Включать автоматически при афк (Нужно находиться дома)", igvars.autohawkafk) then
								ini.config.autohawkafk = igvars.autohawkafk.v
								inicfg.save(cfg, d_ini)
							end
							imgui.NewLine()
							imgui.PushFont(font[15])
							imgui.Text(u8'Тип триггера:')
							imgui.PopFont()
							imgui.PushItemWidth(140)
							if imgui.Combo(u8(''), igvars.checkmethod, checklist, -1) then
								ini.config.checkmethod = igvars.checkmethod.v
								inicfg.save(cfg, d_ini)
							end
							imgui.PopItemWidth()
							if igvars.checkmethod.v == 1 then
								imgui.PushItemWidth(40)
								imgui.SameLine()
								if imgui.InputInt(u8('При скольки процентах голода надо кушать'), igvars.eat2met, 0) then
									ini.config.eat2met = igvars.eat2met.v
									inicfg.save(cfg, d_ini)
								end
								imgui.PopItemWidth()
							end
							imgui.NewLine()
							if imgui.ToggleButton(u8'АвтоХил', igvars.healstate) then
								ini.config.healstate = igvars.healstate.v
								inicfg.save(cfg, d_ini)
							end
							if igvars.healstate.v then
								imgui.PushItemWidth(40)
								if imgui.InputInt(u8'Уровень ХП для Хила', igvars.hplvl,0) then
									ini.config.hplvl = igvars.hplvl.v
									inicfg.save(cfg, d_ini)
								end
								imgui.PopItemWidth()
								imgui.Text(u8'Метода хила:')
								imgui.PushItemWidth(100)
								if imgui.Combo('##hpmetod',igvars.hpmetod,healmetod,-1) then
									ini.config.hpmetod = igvars.hpmetod.v
									inicfg.save(cfg, d_ini)
								end
								imgui.PopItemWidth()
							end
						end
						imgui.NewLine()
						imgui.Text(u8'Авто Сундуки:')
						if not igvars.autochest.v then
							imgui.PushFont(font[20])
							imgui.CenterText(u8'Авто Сундуки выключены')
							imgui.PopFont()
						else
							if imgui.ToggleButton(u8'Открывать обычный сундук', tr.openStartChest) then
								if tr.openStartChest.v then
									check_chest = true
									sampSendClickTextdraw(65535)
									sampSendChat("/invent")
								end
							end
							if imgui.Checkbox(u8'Отправлять в вк что выпало', igvars.vkcheststart) then
								ini.config.vkcheststart = igvars.vkcheststart.v
								inicfg.save(cfg, d_ini)
							end
						end
					elseif navigation.current == 3 then -- Биндер
						if rkeysdownload then
							sampAddChatMessage('[MRH:Error] {ffffff}Скрипт перезагружен', ini.config.clrtext)
							tr.reloadR = true
							thisScript():reload()
						else
							local tLastKeys = {}
							imgui.BeginChild("##bindlist", imgui.ImVec2(590, 292))
							for k, v in ipairs(tBindList) do
								if not igvars.binder.v then
									if k <= 4 then
										if hk.HotKey("##HK" .. k, v, tLastKeys, 80) then
											if not rkeys.isHotKeyDefined(v.v) then
												if rkeys.isHotKeyDefined(tLastKeys.v) then
													rkeys.unRegisterHotKey(tLastKeys.v)
												end
												rkeys.registerHotKey(v.v, true, onHotKey)

												if doesFileExist(file) then
													os.remove(file)
												end
												local f = io.open(file, "w")
												if f then
													f:write(encodeJson(tBindList))
													f:close()
												end

											end
										end
										imgui.SameLine()
										if tEditData.id ~= k then
											local sText = v.text
											--imgui.BeginChild("##cliclzone" .. k, imgui.ImVec2(500, 21))
											imgui.AlignTextToFramePadding()
											if sText:len() > 0 then
												imgui.Text(u8(sText))
											else
												imgui.TextDisabled(u8("Пустое сообщение ..."))
											end
											--imgui.EndChild()
											if imgui.IsItemClicked()  and k >= 5 then
												sInputEdit.v = sText:len() > 0 and u8(sText) or ""
												tEditData.id = k
												tEditData.inputActve = true
											end
										else
											imgui.PushAllowKeyboardFocus(false)
											imgui.PushItemWidth(250)
											local save = imgui.InputText("##Edit" .. k, sInputEdit, imgui.InputTextFlags.EnterReturnsTrue)
											imgui.PopItemWidth()
											imgui.PopAllowKeyboardFocus()
											if save then
												tBindList[tEditData.id].text = u8:decode(sInputEdit.v)
												tEditData.id = -1
											end
											if tEditData.inputActve then
												tEditData.inputActve = false
												imgui.SetKeyboardFocusHere(-1)
											end
										end
									end
								else
									if hk.HotKey("##HK" .. k, v, tLastKeys, 80) then
										if not rkeys.isHotKeyDefined(v.v) then
											if rkeys.isHotKeyDefined(tLastKeys.v) then
												rkeys.unRegisterHotKey(tLastKeys.v)
											end
											rkeys.registerHotKey(v.v, true, onHotKey)

											if doesFileExist(file) then
												os.remove(file)
											end
											local f = io.open(file, "w")
											if f then
												f:write(encodeJson(tBindList))
												f:close()
											end

										end
									end
									imgui.SameLine()
									if tEditData.id ~= k then
										local sText = v.text
										imgui.BeginChild("##cliclzone" .. k, imgui.ImVec2(435, 20 ))
										--imgui.AlignTextToFramePadding()
										if sText:len() > 0 then
											imgui.Text(u8(sText))
										else
											imgui.TextDisabled(u8("Пустое сообщение ..."))
										end
										imgui.EndChild()
										if imgui.IsItemClicked() and k >= 5 then
											sInputEdit.v = sText:len() > 0 and u8(sText) or ""
											tEditData.id = k
											tEditData.inputActve = true
										end
									else
										imgui.PushAllowKeyboardFocus(false)
										imgui.PushItemWidth(435)
										local save = imgui.InputText("##Edit" .. k, sInputEdit, imgui.InputTextFlags.EnterReturnsTrue)
										imgui.PopItemWidth()
										imgui.PopAllowKeyboardFocus()
										if save then
											tBindList[tEditData.id].text = u8:decode(sInputEdit.v)
											tEditData.id = -1
										end
										if tEditData.inputActve then
											tEditData.inputActve = false
											imgui.SetKeyboardFocusHere(-1)
										end
									end
									if k >= 5 then
										imgui.SameLine()
										if imgui.Button(u8"Удалить##"..k) then
											global_k = k
											imgui.OpenPopup('##DeleteBind')
										end
									end
								end
								if k == 4 then
									imgui.Separator()
									if not igvars.binder.v then
										imgui.PushFont(font[24])
										imgui.CenterText(u8'Включите Биндер в разделе Хелпер')
										imgui.PopFont()	
									end
								end
							end
							imgui.SetNextWindowSize(imgui.ImVec2(220, 52))
							if imgui.BeginPopupModal('##DeleteBind', _, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
								local wsize = imgui.GetWindowSize()
								imgui.CenterText(u8"Вы точно хотите удалить бинд?")

								if imgui.Button(u8'Удалить', imgui.ImVec2(100, 0)) then
									if rkeys.isHotKeyDefined(tLastKeys.v) then rkeys.unRegisterHotKey(tLastKeys.v) end
									table.remove(tBindList, global_k)
									
									if doesFileExist(file) then
										os.remove(file)
									end
									local f = io.open(file, "w")
									if f then
										f:write(encodeJson(tBindList))
										f:close()
									end
									imgui.CloseCurrentPopup()
								end
								imgui.SameLine()
								if imgui.Button(u8'Отменить', imgui.ImVec2(100, 0)) then
									imgui.CloseCurrentPopup()
								end
								imgui.EndPopup() 
							end
							imgui.EndChild()
							if igvars.binder.v then
								imgui.Separator()
							
								if imgui.Button(u8"Добавить бинд") then
									tBindList[#tBindList + 1] = {text = "", v = {}}
								end
								imgui.SameLine(487)
								if imgui.Button(u8"Локальные Теги") then
									imgui.OpenPopup(u8("Локальные Теги"))
								end
								taginfo()
							end
						end
					elseif navigation.current == 4 then
						--imgui.NewLine()
						imgui.Text(u8('Аккаунт:'))
						imgui.PushItemWidth(192)
						if imgui.InputText(u8"Ник##nick_n", igvars.nick_n) then
							ini.config.nick_name = igvars.nick_n.v
							inicfg.save(cfg, d_ini)
						end
						imgui.PopItemWidth()
						imgui.PushItemWidth(70)
						if imgui.InputText(u8"Пароль", igvars.pass_w, imgui.InputTextFlags.Password) then
							ini.config.parol = igvars.pass_w.v
							inicfg.save(cfg, d_ini)
						end
						imgui.SameLine()
						if imgui.InputText(u8"Пинкод", igvars.pin_cod, imgui.InputTextFlags.Password) then
							ini.config.pincod = igvars.pin_cod.v
							inicfg.save(cfg, d_ini)
						end
						imgui.NewLine()
						imgui.Text(u8('Таймцикл:'))
						imgui.PushItemWidth(250)
						if imgui.SliderInt(u8"Время##sett", igvars.sett, -1, 23) then
							if igvars.sett.v == -1 then 
								igvars.sett.v = readMemory(0xB70153, 1, true) 
							end
							ini.config.sett = igvars.sett.v
							inicfg.save(cfg, d_ini)
						end
						if imgui.SliderInt(u8"Погода##setw", igvars.setw, -1, 50) then
							if igvars.setw.v == -1 then
								igvars.setw.v = readMemory(0xC81320, 1, true) 
							end
							ini.config.setw = igvars.setw.v
							inicfg.save(cfg, d_ini)
						end
						if imgui.AnimatedButton(u8"Сохранить погоду", imgui.ImVec2(120,20)) then
							imgui.OpenPopup('##SaveWeather')
						end
                        for i = 1, #cfg1.presets.weather do
                            if cfg1.presets.weather[i] then
                            	if imgui.Button(u8(cfg1.presets.weather[i][1]..'##'..i), imgui.ImVec2(112,20)) then
									if cfg1.presets.weather[i][2] == -1 then 
										igvars.sett.v = readMemory(0xB70153, 1, true) 
									else
										igvars.sett.v = cfg1.presets.weather[i][2]
									end
									
									if cfg1.presets.weather[i][3] == -1 then
										igvars.setw.v = readMemory(0xC81320, 1, true) 
									else
										igvars.setw.v = cfg1.presets.weather[i][3]
									end

									ini.config.sett = igvars.sett.v
									ini.config.setw = igvars.setw.v
									inicfg.save(cfg, d_ini)
								end
								imgui.SameLine()
								if imgui.Button(fa.ICON_FA_TRASH..'##'..i, imgui.ImVec2(20,20)) then
									global_i = i
									imgui.OpenPopup('##DeleteWeather')
								end
								
								imgui.SameLine()
								if i % 4 == 0 then
									imgui.NewLine()
								end
                            end
                        end
						imgui.PopItemWidth()
						imgui.SetNextWindowSize(imgui.ImVec2(220, 80))
						if imgui.BeginPopupModal('##SaveWeather', _, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
                            local wsize = imgui.GetWindowSize()
                            imgui.CenterText(u8"Введите название")
							imgui.PushItemWidth(205)
							imgui.InputText("", igvars.name_bind_weather)
							imgui.PopItemWidth()
							if imgui.Button(u8'Сохранить', imgui.ImVec2(100, 0)) then
								table.insert(cfg1.presets.weather, {u8:decode(igvars.name_bind_weather.v), igvars.sett.v, igvars.setw.v})
								imgui.CloseCurrentPopup()
							end
							imgui.SameLine()
							if imgui.Button(u8'Отменить', imgui.ImVec2(100, 0)) then
								imgui.CloseCurrentPopup()
							end
                            imgui.EndPopup() 
                        end

						imgui.SetNextWindowSize(imgui.ImVec2(220, 50))
						if imgui.BeginPopupModal('##DeleteWeather', _, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
                            local wsize = imgui.GetWindowSize()
                            imgui.CenterText(u8"Вы уверены?")

							if imgui.Button(u8'Удалить', imgui.ImVec2(100, 0)) then
								table.remove(cfg1.presets.weather, global_i)
								imgui.CloseCurrentPopup()
							end
							imgui.SameLine()
							if imgui.Button(u8'Закрыть', imgui.ImVec2(100, 0)) then
								imgui.CloseCurrentPopup()
							end
                            imgui.EndPopup() 
                        end
					elseif navigation.current == 5 then
						--imgui.NewLine()
						imgui.CenterText(u8'ВАЖНО! При загрузке не перезагружайте скрипт')
						if imgui.ButtonClickable(tr.clickarz, u8"Скачать модели",imgui.ImVec2(142,20), 0.5, true) then
							dl_files = 0
							tr.clickarz = false
							remove_f()
							lua_thread.create(dlmodel)
						end
						imgui.SameLine()
						if imgui.ButtonClickable(tr.clickupd, u8"Обновить модели",imgui.ImVec2(142,20), 0.5, true) then
							lua_thread.create(dlmodel_upd)
						end
						if tr.clickarz == false and not dl_status then
							imgui.SameLine()
							if imgui.Button(u8"Отменить загрузку", imgui.ImVec2(142,20)) then
								stop_downloading = true
								tr.clickarz = true
							end
						end
						if tr.clickarz == false and not dl_status then
							imgui.Text(string.format(u8'Скачено файлов: %d из 17', dl_files))
							imgui.Text(string.format(u8'Загружено %.2f МБ из %.2f МБ.', pp1 / 1024 / 1024, pp2 / 1024 / 1024))
						end
						if dl_status then
							imgui.Text(u8'Модели загружены, перезапустите игру..')
						end
						imgui.NewLine()
						if imgui.ButtonClickable(tr.clickarzvoice, u8"Скачать голосовой чат",imgui.ImVec2(142,20), 0.5, true) then
							dl_files = 0
							tr.clickarzvoice = false
							lua_thread.create(dlvoice)
						end
						if tr.clickarzvoice == true and not dl_status1 then -- tr.clickarzvoice == false
							imgui.SameLine()
							if imgui.Button(u8"Отменить загрузку", imgui.ImVec2(142,20)) then
								stop_downloading = true
								tr.clickarzvoice = true
							end
						end
						if tr.clickarzvoice == false and not dl_status1 then -- tr.clickarzvoice == false
							imgui.Text(string.format(u8'Скачено файлов: %d из 5', dl_files))
							imgui.Text(string.format(u8'Загружено %.2f МБ из %.2f МБ.', pp1 / 1024 / 1024, pp2 / 1024 / 1024))
						end
						if dl_status1 then
							imgui.Text(u8'Голосовой чат загружен, перезапустите игру..')
						end
					elseif navigation.current == 6 then -- клады
						if imgui.Checkbox(u8"Имба нарко##isEnablenarko", igvars.isEnablenarko) then
							if tr.isEnablenarko then 
								tr.isEnablenarko = false
							else
								get_coords_narko()
								tr.isEnablenarko = true
								lua_thread.create(narko3d, true)
							end 
						end
						imgui.SameLine(150)
						if imgui.Checkbox(u8"Имба клады##isEnableklad", igvars.isEnableklad) then
							if tr.isEnableklad then
								tr.isEnableklad = false
							else 
								get_coords(false)
								tr.isEnableklad = true
								lua_thread.create(klad3d, true)
							end 
						end
						imgui.SameLine(300)
						if imgui.Checkbox(u8"Имба клады 2##isEnableklad_new", igvars.isEnableklad_new) then
							if tr.isEnableklad_new then
								tr.isEnableklad_new = false
							else 
								get_coords(false)
								tr.isEnableklad_new = true
								lua_thread.create(klad3d_new, true)
							end 
						end
						imgui.SameLine(450)
						if imgui.Checkbox(u8"Тресера имба клады##tracerklad", igvars.tracerklad) then
							ini.config.tracerklad = igvars.tracerklad.v
							inicfg.save(cfg, d_ini)
						end
					end
				elseif tab.v == 3 then
					imgui.NewLine()
					if imgui.ToggleButton(u8"Включить уведомления", igvars.vknotf) then
						if igvars.vknotf.v then
							sampAddChatMessage('[MRH] {ffffff}Что-бы работали уведомления, перезапустите скрипт.', ini.config.clrtext)
						end
						ini.config.vk_notf = igvars.vknotf.v
						inicfg.save(cfg, d_ini)
					end
					imgui.NewLine()
					if igvars.vknotf.v then
						imgui.PushItemWidth(150)
						if imgui.InputText(u8"Ид своей страницы##user_id", igvars.user_id) then
							ini.config.userid = igvars.user_id.v
							inicfg.save(cfg, d_ini)
						end
						imgui.PopItemWidth()
						imgui.NewLine()
						if imgui.Checkbox(u8"PayDay##vk_payday", igvars.vk_payday) then
							ini.config.vk_pay_day = igvars.vk_payday.v
							inicfg.save(cfg, d_ini)
						end
						imgui.SameLine()
						if imgui.Checkbox(u8"Подключение##vk_initgame", igvars.vk_initgame) then
							ini.config.vk_init_game = igvars.vk_initgame.v
							inicfg.save(cfg, d_ini)
						end
						imgui.SameLine()
						if imgui.Checkbox(u8"Краш скрипта##vk_crash", igvars.vk_crash) then
							ini.config.vk_crash_game = igvars.vk_crash.v
							inicfg.save(cfg, d_ini)
						end
						imgui.SameLine()
						if imgui.Checkbox(u8"Чат игры в вк##vk_listen", igvars.vk_listen) then
							ini.config.vk_listen = igvars.vk_listen.v
							inicfg.save(cfg, d_ini)
						end
						imgui.NewLine()
						imgui.Text(u8'Секрет!')
						imgui.Hint('hintSecret', u8'Ты меня не видел)')
					end
				elseif tab.v == 4 then
					imgui.SetCursorPos(imgui.ImVec2(50,6))
					if devmode then
						for i, title in ipairs(navigation2.list) do
							if HeaderButton(navigation2.current == i, title) then
								navigation2.current = i
							end
							if i ~= #navigation2.list then
								imgui.SameLine(nil, 35)
							end
						end
						imgui.SetCursorPos(imgui.ImVec2(-1, 27))
						imgui.Separator()
						imgui.SetCursorPos(imgui.ImVec2(8, 40))

						if navigation2.current == 3 then 
							imgui.PushFont(font[20])
							for day = 1, 6 do 
								imgui.Text(u8(tWeekdays[day])); imgui.SameLine(200)
								imgui.Text(get_clock(cfg.myWeekOnline[day]))
							end
							imgui.Text(u8(tWeekdays[0])); imgui.SameLine(200)
							imgui.Text(get_clock(cfg.myWeekOnline[0]))
							
							imgui.TextColoredRGB('{0087FF}Всего отыграно: '); imgui.SameLine(200)
							imgui.TextColoredRGB('{0087FF}'..get_clock(cfg.onWeek.full))
							imgui.PopFont()
						end
					else
						imgui.PushFont(font[60])

						imgui.SameLine(250)
						imgui.TextColoredRGB('{0087FF}:)')

						imgui.PopFont()
					end
			
				elseif tab.v == 5 then
					imgui.Columns(5)
					imgui.Separator()
					imgui.SetColumnWidth(-1, 25) imgui.CenterColumnText(u8'№'); imgui.NextColumn()
					imgui.SetColumnWidth(-1, 165) imgui.CenterColumnText(u8'1 предмет'); imgui.NextColumn()
					imgui.SetColumnWidth(-1, 165) imgui.CenterColumnText(u8'2 предмет'); imgui.NextColumn()
					imgui.SetColumnWidth(-1, 165); imgui.CenterColumnText(u8'3 предмет'); imgui.NextColumn()
					imgui.SetColumnWidth(-1, 105); imgui.CenterColumnText(u8'Дата'); imgui.NextColumn()

					for i = #cfg2.logs.klad, 1, -1 do
						imgui.Separator()
						imgui.Text(i); imgui.NextColumn()
						imgui.Text(u8(cfg2.logs.klad[i][2])..u8'\nКоличество: '..u8(cfg2.logs.klad[i][3])); imgui.NextColumn()
						imgui.Text(u8(cfg2.logs.klad[i][4])..u8'\nКоличество: '..u8(cfg2.logs.klad[i][5])); imgui.NextColumn()
						imgui.Text(u8(cfg2.logs.klad[i][6])..u8'\nКоличество: '..u8(cfg2.logs.klad[i][7])); imgui.NextColumn()
						imgui.Text(  (cfg2.logs.klad[i][1]):gsub(' | ', '\n')  ); imgui.NextColumn()
					end

					imgui.Columns(1); imgui.Separator()
				elseif tab.v == 6 then
					imgui.PushFont(font[20])
						imgui.Text(u8(scinfo))
					imgui.PopFont()
				elseif tab.v == 7 then
					imgui.BeginChild("##updlog", imgui.ImVec2(-1, -1), false)
						if imgui.CollapsingHeader(u8'Обновление 1.8##1.8') then
							imgui.Text('') imgui.SameLine() imgui.Text(u8"1. Добавлен перевод команд (Отправляя в чат \".мк привет\" скрипт заменит на \"/vr привет\")")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"2. Добавлен калькулятор (При вводе в чат например \"1+1\", ответ появится ниже)")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"3. Добавлена функция смена стиля в разделе \"Управление\"")
						end
						if imgui.CollapsingHeader(u8'Обновление 1.9##1.9') then
							imgui.Text('') imgui.SameLine() imgui.Text(u8"1. Добавлены вопросы с кладов (33 [76])")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"2. Добавлена активация чит. функций")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"3. Мелкие фиксы")
						end
						if imgui.CollapsingHeader(u8'Обновление 2.0##2.0') then
							imgui.Text('') imgui.SameLine() imgui.Text(u8"1. Добавлены вопросы с кладов (44 [120])")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"2. Добавлен Кам хак")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"3. Фиксы багов")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"4. Добавлена анти ломка")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"5. Добавлен бесконечный бег")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"6. Добавлено время (Не работает)")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"7. Добавлен быстрый армор [ALT + 1]")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"8. Добавлен быстрый трейд [ALT + 2]")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"9. Добавлено быстрое нарко [ALT + 3]")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"10. Добавлено разделение денег запятыми в диалогах (Было - 19228228; Стало - 19,228,228)")
						end
						if imgui.CollapsingHeader(u8'Обновление 2.1##2.1') then
							imgui.Text('') imgui.SameLine() imgui.Text(u8"1. Перенесены все функции из Настроек в Хелпер")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"2. Функция времени теперь работает")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"3. Обновлена полностью функция перевод команд")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"4. Добавлено запоминане диалогов")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"5. Доработан Авто логин")
						end
						if imgui.CollapsingHeader(u8'Обновление 2.2##2.2') then
							imgui.Text('') imgui.SameLine() imgui.Text(u8"1. Добавлен имба клады")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"2. Добавлен трейсера на имба клады")
						end
						if imgui.CollapsingHeader(u8'Обновление 2.3##2.3') then
							imgui.Text('') imgui.SameLine() imgui.Text(u8"1. Пофикшен запоминание диалогов")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"2. Пофикшен имба клады, теперь скрипт не крашит")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"3. Пофикшены некоторые баги")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"4. Добавлен имба нарко")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"5. Добавлен Чат")
						end
						if imgui.CollapsingHeader(u8'Обновление 2.4##2.4') then
							imgui.Text('') imgui.SameLine() imgui.Text(u8"1. Теперь в чате другой хост (Загружается за 0-1с, раньше 4-8с)")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"2. Пофикшен /ifix, Вход в дом")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"3. Фикс ответов на клады")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"4. Добавлен новый репорт")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"5. Обновлены ответы на клады")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"6. Добавлен Вкоин бот *_*")
						end
						if imgui.CollapsingHeader(u8'Обновление 2.5##2.5') then
							imgui.Text('') imgui.SameLine() imgui.Text(u8"1. Добавлено убирание кустов")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"2. Добавлена команда /crep")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"3. Фикс очистка ненужных диалогов")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"4. Добавлена быстрая маска [ALT + 4]")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"5. Добавлен +FPS ЦР")
						end
						if imgui.CollapsingHeader(u8'Обновление 2.6##2.6') then
							imgui.Text('') imgui.SameLine() imgui.Text(u8"1. НОВЫЙ ИНТЕРФЕЙС")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"2. Вход в дом теперь на ALT")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"3. Небольшие фиксы")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"4. Добавлена 1 новая метка клада")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"5. Добавлен перевод секунд в минут деморган/мут")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"6. Теперь скрипт не должен вообще крашить")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"7. Добавлена команда /cpos")
						end
						if imgui.CollapsingHeader(u8'Обновление 2.7##2.7') then
							imgui.Text('') imgui.SameLine() imgui.Text(u8"1. Оптимизация скрипта")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"2. Добавлена Авто еда")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"3. Добавлены уведомления")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"4. *2 Пофикшены баги")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"5. *2 Теперь работают уведомления вк")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"6. *3 Увеличен размер уведомлений")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"7. *4 Скрипт еще больше оптимизирован")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"8. *5 Добавлена чистая стата")
						end
						if imgui.CollapsingHeader(u8'Обновление 2.8##2.8') then
							imgui.Text('') imgui.SameLine() imgui.Text(u8"1. Добавлен раздел Загрузки в Настройках")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"2. Добавлено сохранение погоды")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"3. Убраны подвисания")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"4. Добавлен биндер")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"5. Добавлены резервные точки кладов")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"6. *2 Фикс кладов и ответов")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"7. *2 Добавлена новая команда /mshowmc, убрна чистая стата")
						end
						if imgui.CollapsingHeader(u8'Обновление 2.9##2.9') then
							imgui.Text('') imgui.SameLine() imgui.Text(u8"1. Переделаны имба клады. Перенесены в Настроки")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"2. Добавлена новая команда /pcar")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"3. Добавлено изменение цвет текста скрипта во вкладке Стиль")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"4. Добавлены Логи")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"5. Добавлен Информер")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"6. Фиксы скрипта")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"7. Добавлен Авто Сундуки")
							imgui.Text('') imgui.SameLine() imgui.Text(u8"8. Добавлен Авто сбор велика")
						end
					imgui.EndChild()
				end
            imgui.EndChild()
        imgui.End()
    end
	GlobalNotify()
end

function GlobalNotify()
	notify.active = 0
	for k, v in ipairs(notify.messages) do
		local push = false
		if v.active and v.time < os.clock() then
			v.active = false
		end

		if notify.active < notify.max then
			if not v.active then
				if v.showtime > 0 then
					v.active = true
					v.time = os.clock() + v.showtime
					v.showtime = 0
				end
			end
			if v.active then
				notify.active = notify.active + 1
				if v.time + 3.000 >= os.clock() then
					imgui.PushStyleVar(imgui.StyleVar.Alpha, (v.time - os.clock()) / 1.0)
					push = true
				end
				notify.list.pos = imgui.ImVec2(notify.list.pos.x, notify.list.pos.y - 90)

				imgui.SetNextWindowPos(notify.list.pos, _, imgui.ImVec2(0.0, 0.25))
				imgui.SetNextWindowSize(imgui.ImVec2(260, 80))
				imgui.PushStyleVar(imgui.StyleVar.WindowRounding, 5.0)
				imgui.PushStyleVar(imgui.StyleVar.WindowPadding, imgui.ImVec2(0.0, 0.0))
				imgui.PushStyleVar(imgui.StyleVar.ChildWindowRounding, 5.0)
				imgui.Begin(u8'##notifycard'..k, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
					
					local p = imgui.GetCursorScreenPos()
					local ws = imgui.GetWindowSize()
					local bar_size = (v.bar_time - (os.clock() - v.start)) / ( v.bar_time / ws.x )
					if bar_size > 0 then
						imgui.GetWindowDrawList():AddRectFilled(
							imgui.ImVec2(p.x, p.y + (ws.y - 5)), 
							imgui.ImVec2(p.x + bar_size, p.y + ws.y), 
							imgui.ColorConvertFloat4ToU32(imgui.ImVec4(0.0, 0.5, 1.0, (v.time - os.clock()) / 1.0)), 
							5, 
							bar_size == ws.x and 12 or 8
						)
					end
					imgui.SetCursorPos(imgui.ImVec2(5, 5))
					imgui.SameLine(nil, 10)
					imgui.BeginGroup()
						imgui.SetCursorPosY(7.5)
						imgui.PushFont(font[20])
						imgui.CenterTextColoredRGB('{7FFF00}[Информация]')
						imgui.PopFont()
						imgui.PushFont(font[15])
						imgui.CenterTextColoredRGB(tostring(v.text))
						imgui.PopFont()
					imgui.EndGroup()
				imgui.End()
				imgui.PopStyleVar(3)
				if push then
					imgui.PopStyleVar()
				end
			end
		end
	end
	notf_sX, notf_sY = convertGameScreenCoordsToWindowScreenCoords(605, 438)
	notify.list = {
		pos = { x = notf_sX - 200, y = notf_sY + 20 },
		npos = { x = notf_sX - 200, y = notf_sY },
		size = { x = 200, y = 0 }
	}
end

if brk then
	function rkeys.onHotKey(id, keys)
		if sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive() then
			return false
		end
	end
end

function onHotKey(id, keys)
	local sKeys = tostring(table.concat(keys, " "))
	for k, v in pairs(tBindList) do
		if k <= 4 or igvars.binder.v then
			if sKeys == tostring(table.concat(v.v, " ")) then
				if tostring(v.text):len() > 0 then
					sampSendChat(v.text)
				end
			end
		end
	end
end

function addNotify(text, time)
	notify.messages[#notify.messages + 1] = { 
		active = false, 
		time = 0, 
		showtime = time,
		text = text,
		start = os.clock(),
		bar_time = time - 1
	}
end

function apply_custom_style()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local ImFloat4 = imgui.ImFloat4
	colors[imgui.Col.ScrollbarBg] = ImFloat4(0.02, 0.02, 0.02, 0.53)
    colors[imgui.Col.ScrollbarGrab] = ImFloat4(0.31, 0.31, 0.31, 1.00)
    colors[imgui.Col.ScrollbarGrabHovered] = ImFloat4(0.41, 0.41, 0.41, 1.00)
    colors[imgui.Col.ScrollbarGrabActive] = ImFloat4(0.51, 0.51, 0.51, 1.00)
	colors[imgui.Col.TextSelectedBg] = ImFloat4(0.26, 0.59, 0.98, 0.35)
	colors[imgui.Col.Text] = textClr
	colors[imgui.Col.TextDisabled] = ImFloat4(0.50, 0.50, 0.50, 1.00)
	colors[imgui.Col.WindowBg] = WindowBg
	colors[imgui.Col.ChildWindowBg] = ImFloat4(0.00, 0.00, 0.00, 0.00)
	colors[imgui.Col.PopupBg] = ImFloat4(0.00, 0.00, 0.00, 1.00)
	colors[imgui.Col.Border] = ImFloat4(1.00, 1.00, 1.00, 1.00)
	colors[imgui.Col.BorderShadow] = ImFloat4(1.00, 1.00, 1.00, 0.40)
	colors[imgui.Col.Header] = TitleBg
	colors[imgui.Col.HeaderHovered] = ImFloat4(ini.config.TitleBg1, ini.config.TitleBg2, ini.config.TitleBg3, ini.config.TitleBg4/1.5)
	colors[imgui.Col.HeaderActive] = ImFloat4(ini.config.TitleBg1, ini.config.TitleBg2, ini.config.TitleBg3, ini.config.TitleBg4/2)
	colors[imgui.Col.MenuBarBg] = ImFloat4(0.00, 0.46, 0.65, 1.00)
	colors[imgui.Col.FrameBg] = FrameBg
	colors[imgui.Col.FrameBgHovered] = imgui.ImFloat4(ini.config.FrameBg1, ini.config.FrameBg2, ini.config.FrameBg3, ini.config.FrameBg4/1.5)
	colors[imgui.Col.FrameBgActive] = imgui.ImFloat4(ini.config.FrameBg1, ini.config.FrameBg2, ini.config.FrameBg3, ini.config.FrameBg4/2)
	colors[imgui.Col.TitleBg] = TitleBg
	colors[imgui.Col.TitleBgCollapsed] = TitleBg
	colors[imgui.Col.TitleBgActive] = TitleBg
	colors[imgui.Col.Button] = FrameBg
	colors[imgui.Col.ButtonHovered] = imgui.ImFloat4(ini.config.FrameBg1, ini.config.FrameBg2, ini.config.FrameBg3, ini.config.FrameBg4/1.5)
	colors[imgui.Col.ButtonActive] = imgui.ImFloat4(ini.config.FrameBg1, ini.config.FrameBg2, ini.config.FrameBg3, ini.config.FrameBg4/2)

	style.WindowPadding = imgui.ImVec2(8, 8)
	style.WindowRounding = 4
	style.ChildWindowRounding = 5
	style.FramePadding = imgui.ImVec2(5, 3)
	style.FrameRounding = 2.0
	style.ItemSpacing = imgui.ImVec2(5, 4)
	style.ItemInnerSpacing = imgui.ImVec2(4, 4)
	style.IndentSpacing = 21
	style.ScrollbarSize = 10
	style.ScrollbarRounding = 9
	style.GrabMinSize = 8
	style.GrabRounding = 1
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
end
function imgui.CreatePaddingY(y)
	y = y or 8
	local cc = imgui.GetCursorPos()
	imgui.SetCursorPosY(cc.y+y)
end
function imgui.CreatePaddingX(x)
	x = x or 8
	local cc = imgui.GetCursorPos()
	imgui.SetCursorPosX(cc.x+x)
end
function imgui.CreatePaddingY(y)
	y = y or 8
	local cc = imgui.GetCursorPos()
	imgui.SetCursorPosY(cc.y+y)
end
function imgui.CreatePadding(x,y)
	x,y = x or 8, y or 8
	local cc = imgui.GetCursorPos()
	imgui.SetCursorPos(imgui.ImVec2(cc.x+x,cc.y+y))
end
function imgui.CenterText(text) 
	local width = imgui.GetWindowWidth()
	local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end
function imgui.Hint(str_id, hint, delay)
    local hovered = imgui.IsItemHovered()
    local animTime = 0.2
    local delay = delay or 0.00
    local show = true

    if not allHints then allHints = {} end
    if not allHints[str_id] then
        allHints[str_id] = {
            status = false,
            timer = 0
        }
    end

    if hovered then
        for k, v in pairs(allHints) do
            if k ~= str_id and os.clock() - v.timer <= animTime  then
                show = false
            end
        end
    end

    if show and allHints[str_id].status ~= hovered then
        allHints[str_id].status = hovered
        allHints[str_id].timer = os.clock() + delay
    end

    if show then
        local between = os.clock() - allHints[str_id].timer
        if between <= animTime then
            local s = function(f)
                return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
            end
            local alpha = hovered and s(between / animTime) or s(1.00 - between / animTime)
            --imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, alpha)
            imgui.SetTooltip(hint)
            --imgui.PopStyleVar()
        elseif hovered then
            imgui.SetTooltip(hint)
        end
    end
end
function imgui.AnimatedButton(label, size, speed, rounded)
    local size = size or imgui.ImVec2(0, 0)
    local bool = false
    local text = label:gsub('##.+$', '')
    local ts = imgui.CalcTextSize(text)
    speed = speed and speed or 0.4
    if not AnimatedButtons then AnimatedButtons = {} end
    if not AnimatedButtons[label] then
        local color = imgui.GetStyle().Colors[imgui.Col.ButtonHovered]
        AnimatedButtons[label] = {circles = {}, hovered = false, state = false, time = os.clock(), color = imgui.ImVec4(color.x, color.y, color.z, 0.2)}
    end
    local button = AnimatedButtons[label]
    local dl = imgui.GetWindowDrawList()
    local p = imgui.GetCursorScreenPos()
    local c = imgui.GetCursorPos()
    local CalcItemSize = function(size, width, height)
        local region = imgui.GetContentRegionMax()
        if (size.x == 0) then
            size.x = width
        elseif (size.x < 0) then
            size.x = math.max(4.0, region.x - c.x + size.x);
        end
        if (size.y == 0) then
            size.y = height;
        elseif (size.y < 0) then
            size.y = math.max(4.0, region.y - c.y + size.y);
        end
        return size
    end
    size = CalcItemSize(size, ts.x+imgui.GetStyle().FramePadding.x*2, ts.y+imgui.GetStyle().FramePadding.y*2)
    local ImSaturate = function(f) return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f) end
    if #button.circles > 0 then
        local PathInvertedRect = function(a, b, col)
            local rounding = rounded and imgui.GetStyle().FrameRounding or 0
            if rounding <= 0 or not rounded then return end
            local dl = imgui.GetWindowDrawList()
            dl:PathLineTo(a)
            dl:PathArcTo(imgui.ImVec2(a.x + rounding, a.y + rounding), rounding, -3.0, -1.5)
            dl:PathFillConvex(col)

            dl:PathLineTo(imgui.ImVec2(b.x, a.y))
            dl:PathArcTo(imgui.ImVec2(b.x - rounding, a.y + rounding), rounding, -1.5, -0.205)
            dl:PathFillConvex(col)

            dl:PathLineTo(imgui.ImVec2(b.x, b.y))
            dl:PathArcTo(imgui.ImVec2(b.x - rounding, b.y - rounding), rounding, 1.5, 0.205)
            dl:PathFillConvex(col)

            dl:PathLineTo(imgui.ImVec2(a.x, b.y))
            dl:PathArcTo(imgui.ImVec2(a.x + rounding, b.y - rounding), rounding, 3.0, 1.5)
            dl:PathFillConvex(col)
        end
        for i, circle in ipairs(button.circles) do
            local time = os.clock() - circle.time
            local t = ImSaturate(time / speed)
            local color = imgui.GetStyle().Colors[imgui.Col.ButtonActive]
            local color = imgui.GetColorU32(imgui.ImVec4(color.x, color.y, color.z, (circle.reverse and (255-255*t) or (255*t))/255))
            local radius = math.max(size.x, size.y) * (circle.reverse and 1.5 or t)
            imgui.PushClipRect(p, imgui.ImVec2(p.x+size.x, p.y+size.y), true)
            dl:AddCircleFilled(circle.clickpos, radius, color, radius/2)
            PathInvertedRect(p, imgui.ImVec2(p.x+size.x, p.y+size.y), imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.WindowBg]))
            imgui.PopClipRect()
            if t == 1 then
                if not circle.reverse then
                    circle.reverse = true
                    circle.time = os.clock()
                else
                    table.remove(button.circles, i)
                end
            end
        end
    end
    local t = ImSaturate((os.clock()-button.time) / speed)
    button.color.w = button.color.w + (button.hovered and 0.8 or -0.8)*t
    button.color.w = button.color.w < 0.2 and 0.2 or (button.color.w > 1 and 1 or button.color.w)
    color = imgui.GetStyle().Colors[imgui.Col.Button]
    color = imgui.GetColorU32(imgui.ImVec4(color.x, color.y, color.z, 0.5))
    dl:AddRectFilled(p, imgui.ImVec2(p.x+size.x, p.y+size.y), color, rounded and imgui.GetStyle().FrameRounding or 0)
    dl:AddRect(p, imgui.ImVec2(p.x+size.x, p.y+size.y), imgui.GetColorU32(button.color), rounded and imgui.GetStyle().FrameRounding or 0)
    local align = imgui.GetStyle().ButtonTextAlign
    imgui.SetCursorPos(imgui.ImVec2(c.x+(size.x-ts.x)*align.x, c.y+(size.y-ts.y)*align.y))
    imgui.Text(text)
    imgui.SetCursorPos(c)
    if imgui.InvisibleButton(label, size) then
        bool = true
        table.insert(button.circles, {animate = true, reverse = false, time = os.clock(), clickpos = imgui.ImVec2(getCursorPos())})
    end
    button.hovered = imgui.IsItemHovered()
    if button.hovered ~= button.state then
        button.state = button.hovered
        button.time = os.clock()
    end
    return bool
end
function imgui.ButtonClickable(clickable, ...)
    if clickable then
        return imgui.AnimatedButton(...)

    else
        local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
        imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
            imgui.AnimatedButton(...)
        imgui.PopStyleColor()
        imgui.PopStyleColor()
        imgui.PopStyleColor()
        imgui.PopStyleColor()
    end
end

function sp.onPlayerStreamIn(playerId, team, model, position, rotation, color, fightingStyle)
	infnpc[playerId] = { team, model, position, rotation, color, fightingStyle }
	if igvars.fpscr.v then
		for _, handle in ipairs(getAllChars()) do
		  if doesCharExist(handle) then
			local _, id = sampGetPlayerIdByCharHandle(handle)
				if id ~= myid then
					emul_rpc('onPlayerStreamOut', { id })
				end
		  end
		end
		npc[#npc + 1] = playerId
	end
end

function threadHandle(runner, url, args, resolve, reject) -- обработка effil потока без блокировок
	local t = runner(url, args)
	local r = t:get(0)
	while not r do
		r = t:get(0)
		wait(0)
	end
	local status = t:status()
	if status == 'completed' then
		local ok, result = r[1], r[2]
		if ok then resolve(result) else reject(result) end
	elseif err then
		reject(err)
	elseif status == 'canceled' then
		reject(status)
	end
	t:cancel(0)
end

function requestRunner() -- создание effil потока с функцией https запроса
	return effil.thread(function(u, a)
		local https = require 'ssl.https'
		local ok, result = pcall(https.request, u, a)
		if ok then
			return {true, result}
		else
			return {false, result}
		end
	end)
end

function async_http_request(url, args, resolve, reject)
	local runner = requestRunner()
	if not reject then reject = function() end end
	lua_thread.create(function()
		threadHandle(runner, url, args, resolve, reject)
	end)
end

local vkerr, vkerrsend -- сообщение с текстом ошибки, nil если все ок

function loop_async_http_request(url, args, reject)
	local runner = requestRunner()
	if not reject then reject = function() end end
	lua_thread.create(function()
		while true do
			while not keyv do wait(0) end
			url = server .. '?act=a_check&key=' .. keyv .. '&ts=' .. ts .. '&wait=25' --меняем url каждый новый запрос потокa, так как server/key/ts могут изменяться
			threadHandle(runner, url, args, longpollResolve, reject)
		end
	end)
end

function longpollResolve(result)
	if result then
		if result:sub(1,1) ~= '{' then
			vkerr = 'Ошибка!\nПричина: Нет соединения с VK!'
			return
		end
		local t = decodeJson(result)
		if t.failed then
			if t.failed == 1 then
				ts = t.ts
			else
				keyv = nil
				longpollGetKey()
			end
			return
		end
		if t.ts then
			ts = t.ts
		end
		if t.updates then
			for k, v in ipairs(t.updates) do
				if v.type == 'message_new' and v.object.message and tonumber(v.object.message.from_id) == tonumber(igvars.user_id.v) then
					if v.object.message.payload then
						local pl = decodeJson(v.object.message.payload)
						if pl.button then
							if pl.button == 'stats' then
								getPlayerArzStats()
							elseif pl.button == 'pinfo' then
								getPlayerInfo()
							elseif pl.button == 'help' then
								sendvknotf("\nКоманды:\n chat [комманда] - Отправка сообщения в чат\n stats - статистика игрока.\n pinfo - информация о игроке.\n openchest - открыть сундук.\n listen - прослушка чата.")
							end
						end
						return
					end
					if v.object.message.text then
						local text = v.object.message.text
						--local text = v.object.message.text .. ' ' --костыль на случай если одна команда является подстрокой другой (!d и !dc как пример)
						if text == 'stats' then
							getPlayerArzStats()
						elseif text == 'openchest' then
							openchestvk = true
							check_chest1()
						elseif text == 'pinfo' then
							sendvknotf("\nИнформация о игроке")
						elseif text == 'listen' then
							igvars.vk_listen.v = not igvars.vk_listen.v
							ini.config.vk_listen = igvars.vk_listen.v
							if igvars.vk_listen.v and igvars.vknotf.v then
								sendvknotf("\nПрослушка включена")
							else
								sendvknotf("\nПрослушка выключена")
							end
						elseif text == 'help' then
							sendvknotf("\nКоманды:\n chat [комманда] - Отправка сообщения в чат\n stats - статистика игрока.\n pinfo - информация о игроке.\n listen - прослушка чата.")
						elseif text:find('chat (.+)') then
							local args = text:match("chat (.+)")
							if #args > 0 then
								args = u8:decode(args)
								sampProcessChatInput(args)
								sendvknotf('\nСообщение "' .. args .. '" успешно отправлено')
							else
								sendvknotf('\nОшибка')
							end
						elseif text == 'chat' then
							sendvknotf('\nИспользуй: chat [текст]')
						end
					end
				end
			end
		end
	end
end

function longpollGetKey()
	async_http_request('https://api.vk.com/method/groups.getLongPollServer?group_id=' .. group_id .. '&access_token=ac66fe80f89adbe520ef7348f63f2d46622d14fd7b6bd2e441cc8562a83b57cd02434a5f5cfc100d822f0&v=5.131', '', function (result)
		if result then
			if not result:sub(1,1) == '{' then
				vkerr = 'Ошибка!\nПричина: Нет соединения с VK!'
				return
			end
			local t = decodeJson(result)
			if t.error then
				vkerr = 'Ошибка!\nКод: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg
				return
			end
			server = t.response.server
			ts = t.response.ts
			keyv = t.response.key
			vkerr = nil
		end
	end)
end

math.randomseed(os.time())

function sendvknotf(msg, host)
	host = host or sampGetCurrentServerName()
	local acc = sampGetPlayerNickname(select(2,sampGetPlayerIdByCharHandle(playerPed))) .. '['..select(2,sampGetPlayerIdByCharHandle(playerPed))..']'
	msg = msg:gsub('{......}', '')
	msg = '[MRH] '..acc..'\n'..msg
	msg = u8(msg)
	msg = url_encode(msg)
	local keyboard = vkKeyboard()
	keyboard = u8(keyboard)
	keyboard = url_encode(keyboard)
	msg = msg .. '&keyboard=' .. keyboard
	if #igvars.user_id.v > 0 then
		local rnd = math.random(-2147483648, 2147483647)
		async_http_request('https://api.vk.com/method/messages.send', 'peer_id=' .. igvars.user_id.v .. '&random_id=' .. rnd .. '&message=' .. msg .. '&access_token=ac66fe80f89adbe520ef7348f63f2d46622d14fd7b6bd2e441cc8562a83b57cd02434a5f5cfc100d822f0&v=5.131',
		function (result)
			local t = decodeJson(result)
			if not t then
				return
			end
			if t.error then
				vkerrsend = 'Ошибка!\nКод: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg
				return
			end
			vkerrsend = nil
		end)
	end
end
function vkKeyboard() --создает конкретную клавиатуру для бота VK, как сделать для более общих случаев пока не задумывался
	local keyboard = {}
	keyboard.one_time = false
	keyboard.buttons = {}
	keyboard.buttons[1] = {}
	local row = keyboard.buttons[1]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'positive'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "pinfo"}'
	row[1].action.label = 'Статус'
	row[2] = {}
	row[2].action = {}
	row[2].color = 'positive'
	row[2].action.type = 'text'
	row[2].action.payload = '{"button": "stats"}'
	row[2].action.label = 'Статистика'
	row[3] = {}
	row[3].action = {}
	row[3].color = 'primary'
	row[3].action.type = 'text'
	row[3].action.payload = '{"button": "help"}'
	row[3].action.label = 'Помощь'
	return encodeJson(keyboard)
end

function char_to_hex(str)
	return string.format("%%%02X", string.byte(str))
end
  
function url_encode(str)
	local str = string.gsub(str, "\\", "\\")
	local str = string.gsub(str, "([^%w])", char_to_hex)
	return str
end

function irun()
	if igvars.aafk.v then
		memory.setint8(0xB7CEE4, 1)
	else
		memory.setint8(0xB7CEE4, 0)
	end
end

function emul_rpc(hook, parameters)
    local bs_io = require 'samp.events.bitstream_io'
    local handler = require 'samp.events.handlers'
    local extra_types = require 'samp.events.extra_types'
    local hooks = {

        -- Incoming rpcs
        ['onInitGame'] = { 139 },
        ['onPlayerJoin'] = { 'int16', 'int32', 'bool8', 'string8', 137 },
        ['onPlayerQuit'] = { 'int16', 'int8', 138 },
        ['onRequestClassResponse'] = { 'bool8', 'int8', 'int32', 'int8', 'vector3d', 'float', 'Int32Array3', 'Int32Array3', 128 },
        ['onRequestSpawnResponse'] = { 'bool8', 129 },
        ['onSetPlayerName'] = { 'int16', 'string8', 'bool8', 11 },
        ['onSetPlayerPos'] = { 'vector3d', 12 },
        ['onSetPlayerPosFindZ'] = { 'vector3d', 13 },
        ['onSetPlayerHealth'] = { 'float', 14 },
        ['onTogglePlayerControllable'] = { 'bool8', 15 },
        ['onPlaySound'] = { 'int32', 'vector3d', 16 },
        ['onSetWorldBounds'] = { 'float', 'float', 'float', 'float', 17 },
        ['onGivePlayerMoney'] = { 'int32', 18 },
        ['onSetPlayerFacingAngle'] = { 'float', 19 },
        --['onResetPlayerMoney'] = { 20 },
        --['onResetPlayerWeapons'] = { 21 },
        ['onGivePlayerWeapon'] = { 'int32', 'int32', 22 },
        --['onCancelEdit'] = { 28 },
        ['onSetPlayerTime'] = { 'int8', 'int8', 29 },
        ['onSetToggleClock'] = { 'bool8', 30 },
        ['onPlayerStreamIn'] = { 'int16', 'int8', 'int32', 'vector3d', 'float', 'int32', 'int8', 32 },
        ['onSetShopName'] = { 'string256', 33 },
        ['onSetPlayerSkillLevel'] = { 'int16', 'int32', 'int16', 34 },
        ['onSetPlayerDrunk'] = { 'int32', 35 },
        ['onCreate3DText'] = { 'int16', 'int32', 'vector3d', 'float', 'bool8', 'int16', 'int16', 'encodedString4096', 36 },
        --['onDisableCheckpoint'] = { 37 },
        ['onSetRaceCheckpoint'] = { 'int8', 'vector3d', 'vector3d', 'float', 38 },
        --['onDisableRaceCheckpoint'] = { 39 },
        --['onGamemodeRestart'] = { 40 },
        ['onPlayAudioStream'] = { 'string8', 'vector3d', 'float', 'bool8', 41 },
        --['onStopAudioStream'] = { 42 },
        ['onRemoveBuilding'] = { 'int32', 'vector3d', 'float', 43 },
        ['onCreateObject'] = { 44 },
        ['onSetObjectPosition'] = { 'int16', 'vector3d', 45 },
        ['onSetObjectRotation'] = { 'int16', 'vector3d', 46 },
        ['onDestroyObject'] = { 'int16', 47 },
        ['onPlayerDeathNotification'] = { 'int16', 'int16', 'int8', 55 },
        ['onSetMapIcon'] = { 'int8', 'vector3d', 'int8', 'int32', 'int8', 56 },
        ['onRemoveVehicleComponent'] = { 'int16', 'int16', 57 },
        ['onRemove3DTextLabel'] = { 'int16', 58 },
        ['onPlayerChatBubble'] = { 'int16', 'int32', 'float', 'int32', 'string8', 59 },
        ['onUpdateGlobalTimer'] = { 'int32', 60 },
        ['onShowDialog'] = { 'int16', 'int8', 'string8', 'string8', 'string8', 'encodedString4096', 61 },
        ['onDestroyPickup'] = { 'int32', 63 },
        ['onLinkVehicleToInterior'] = { 'int16', 'int8', 65 },
        ['onSetPlayerArmour'] = { 'float', 66 },
        ['onSetPlayerArmedWeapon'] = { 'int32', 67 },
        ['onSetSpawnInfo'] = { 'int8', 'int32', 'int8', 'vector3d', 'float', 'Int32Array3', 'Int32Array3', 68 },
        ['onSetPlayerTeam'] = { 'int16', 'int8', 69 },
        ['onPutPlayerInVehicle'] = { 'int16', 'int8', 70 },
        --['onRemovePlayerFromVehicle'] = { 71 },
        ['onSetPlayerColor'] = { 'int16', 'int32', 72 },
        ['onDisplayGameText'] = { 'int32', 'int32', 'string32', 73 },
        --['onForceClassSelection'] = { 74 },
        ['onAttachObjectToPlayer'] = { 'int16', 'int16', 'vector3d', 'vector3d', 75 },
        ['onInitMenu'] = { 76 },
        ['onShowMenu'] = { 'int8', 77 },
        ['onHideMenu'] = { 'int8', 78 },
        ['onCreateExplosion'] = { 'vector3d', 'int32', 'float', 79 },
        ['onShowPlayerNameTag'] = { 'int16', 'bool8', 80 },
        ['onAttachCameraToObject'] = { 'int16', 81 },
        ['onInterpolateCamera'] = { 'bool', 'vector3d', 'vector3d', 'int32', 'int8', 82 },
        ['onGangZoneStopFlash'] = { 'int16', 85 },
        ['onApplyPlayerAnimation'] = { 'int16', 'string8', 'string8', 'bool', 'bool', 'bool', 'bool', 'int32', 86 },
        ['onClearPlayerAnimation'] = { 'int16', 87 },
        ['onSetPlayerSpecialAction'] = { 'int8', 88 },
        ['onSetPlayerFightingStyle'] = { 'int16', 'int8', 89 },
        ['onSetPlayerVelocity'] = { 'vector3d', 90 },
        ['onSetVehicleVelocity'] = { 'bool8', 'vector3d', 91 },
        ['onServerMessage'] = { 'int32', 'string32', 93 },
        ['onSetWorldTime'] = { 'int8', 94 },
        ['onCreatePickup'] = { 'int32', 'int32', 'int32', 'vector3d', 95 },
        ['onMoveObject'] = { 'int16', 'vector3d', 'vector3d', 'float', 'vector3d', 99 },
        ['onEnableStuntBonus'] = { 'bool', 104 },
        ['onTextDrawSetString'] = { 'int16', 'string16', 105 },
        ['onSetCheckpoint'] = { 'vector3d', 'float', 107 },
        ['onCreateGangZone'] = { 'int16', 'vector2d', 'vector2d', 'int32', 108 },
        ['onPlayCrimeReport'] = { 'int16', 'int32', 'int32', 'int32', 'int32', 'vector3d', 112 },
        ['onGangZoneDestroy'] = { 'int16', 120 },
        ['onGangZoneFlash'] = { 'int16', 'int32', 121 },
        ['onStopObject'] = { 'int16', 122 },
        ['onSetVehicleNumberPlate'] = { 'int16', 'string8', 123 },
        ['onTogglePlayerSpectating'] = { 'bool32', 124 },
        ['onSpectatePlayer'] = { 'int16', 'int8', 126 },
        ['onSpectateVehicle'] = { 'int16', 'int8', 127 },
        ['onShowTextDraw'] = { 134 },
        ['onSetPlayerWantedLevel'] = { 'int8', 133 },
        ['onTextDrawHide'] = { 'int16', 135 },
        ['onRemoveMapIcon'] = { 'int8', 144 },
        ['onSetWeaponAmmo'] = { 'int8', 'int16', 145 },
        ['onSetGravity'] = { 'float', 146 },
        ['onSetVehicleHealth'] = { 'int16', 'float', 147 },
        ['onAttachTrailerToVehicle'] = { 'int16', 'int16', 148 },
        ['onDetachTrailerFromVehicle'] = { 'int16', 149 },
        ['onSetWeather'] = { 'int8', 152 },
        ['onSetPlayerSkin'] = { 'int32', 'int32', 153 },
        ['onSetInterior'] = { 'int8', 156 },
        ['onSetCameraPosition'] = { 'vector3d', 157 },
        ['onSetCameraLookAt'] = { 'vector3d', 'int8', 158 },
        ['onSetVehiclePosition'] = { 'int16', 'vector3d', 159 },
        ['onSetVehicleAngle'] = { 'int16', 'float', 160 },
        ['onSetVehicleParams'] = { 'int16', 'int16', 'bool8', 161 },
        --['onSetCameraBehind'] = { 162 },
        ['onChatMessage'] = { 'int16', 'string8', 101 },
        ['onConnectionRejected'] = { 'int8', 130 },
        ['onPlayerStreamOut'] = { 'int16', 163 },
        ['onVehicleStreamIn'] = { 164 },
        ['onVehicleStreamOut'] = { 'int16', 165 },
        ['onPlayerDeath'] = { 'int16', 166 },
        ['onPlayerEnterVehicle'] = { 'int16', 'int16', 'bool8', 26 },
        ['onUpdateScoresAndPings'] = { 'PlayerScorePingMap', 155 },
        ['onSetObjectMaterial'] = { 84 },
        ['onSetObjectMaterialText'] = { 84 },
        ['onSetVehicleParamsEx'] = { 'int16', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 24 },
        ['onSetPlayerAttachedObject'] = { 'int16', 'int32', 'bool', 'int32', 'int32', 'vector3d', 'vector3d', 'vector3d', 'int32', 'int32', 113 }

    }
    local handler_hook = {
        ['onInitGame'] = true,
        ['onCreateObject'] = true,
        ['onInitMenu'] = true,
        ['onShowTextDraw'] = true,
        ['onVehicleStreamIn'] = true,
        ['onSetObjectMaterial'] = true,
        ['onSetObjectMaterialText'] = true
    }
    local extra = {
        ['PlayerScorePingMap'] = true,
        ['Int32Array3'] = true
    }
    local hook_table = hooks[hook]
    if hook_table then
        local bs = raknetNewBitStream()
        if not handler_hook[hook] then
            local max = #hook_table-1
            if max > 0 then
                for i = 1, max do
                    local p = hook_table[i]
                    if extra[p] then extra_types[p]['write'](bs, parameters[i])
                    else bs_io[p]['write'](bs, parameters[i]) end
                end
            end
        else
            if hook == 'onInitGame' then handler.on_init_game_writer(bs, parameters)
            elseif hook == 'onCreateObject' then handler.on_create_object_writer(bs, parameters)
            elseif hook == 'onInitMenu' then handler.on_init_menu_writer(bs, parameters)
            elseif hook == 'onShowTextDraw' then handler.on_show_textdraw_writer(bs, parameters)
            elseif hook == 'onVehicleStreamIn' then handler.on_vehicle_stream_in_writer(bs, parameters)
            elseif hook == 'onSetObjectMaterial' then handler.on_set_object_material_writer(bs, parameters, 1)
            elseif hook == 'onSetObjectMaterialText' then handler.on_set_object_material_writer(bs, parameters, 2) end
        end
        raknetEmulRpcReceiveBitStream(hook_table[#hook_table], bs)
        raknetDeleteBitStream(bs)
    end
end

function a_afk()
	if igvars.aafk.v then
        memory.setuint8(7634870, 1, false)
        memory.setuint8(7635034, 1, false)
        memory.fill(7623723, 144, 8, false)
        memory.fill(5499528, 144, 6, false)
	else
		memory.setuint8(7634870, 0, false)
        memory.setuint8(7635034, 0, false)
        memory.hex2bin('0F 84 7B 01 00 00', 7623723, 8)
        memory.hex2bin('50 51 FF 15 00 83 85 00', 5499528, 6)
	end
end
function imgui.CenterColumnText(text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    imgui.Text(text)
end
function imgui.ToggleButton(str_id, bool)
    local rBool = false
    if LastActiveTime == nil then
        LastActiveTime = {}
    end
    if LastActive == nil then
        LastActive = {}
    end
    local function ImSaturate(f)
        return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
    end
    local p = imgui.GetCursorScreenPos()
    local draw_list = imgui.GetWindowDrawList()
    local height = imgui.GetTextLineHeightWithSpacing() - 3
    local width = height * 1.55
    local radius = height * 0.50
    local ANIM_SPEED = 0.15
    if imgui.InvisibleButton(str_id, imgui.ImVec2(width, height)) then
        bool.v = not bool.v
        rBool = true
        LastActiveTime[tostring(str_id)] = os.clock()
        LastActive[str_id] = true
    end
    local t = bool.v and 1.0 or 0.0
    if LastActive[str_id] then
        local time = os.clock() - LastActiveTime[tostring(str_id)]
        if time <= ANIM_SPEED then
            local t_anim = ImSaturate(time / ANIM_SPEED)
            t = bool.v and t_anim or 1.0 - t_anim
        else
            LastActive[str_id] = false
        end
    end
    local col_bg
	local col_bg2 = imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.Border])
    if imgui.IsItemHovered() then
        col_bg = imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.FrameBgHovered])
    else
        col_bg = imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.ChildWindowBg])
    end
    draw_list:AddRectFilled(imgui.ImVec2(p.x - 2, p.y - 2), imgui.ImVec2(p.x + width, p.y + height), col_bg2, height * 0.5)
	draw_list:AddRectFilled(p, imgui.ImVec2(p.x + width - 2, p.y + height - 2), col_bg, height * 0.5)
    draw_list:AddCircleFilled(imgui.ImVec2(p.x + radius + t * (width - radius * 2.0) - 1, p.y + radius - 1), radius - 3, imgui.GetColorU32(bool.v and imgui.GetStyle().Colors[imgui.Col.Button] or imgui.GetStyle().Colors[imgui.Col.ButtonHovered]))
	imgui.SameLine()
	imgui.Text(str_id)
	return rBool
end

function imgui.CustomButton(gg, color, colorHovered, colorActive, size)
    local clr = imgui.Col
    imgui.PushStyleColor(clr.Button, color)
    imgui.PushStyleColor(clr.ButtonHovered, colorHovered)
    imgui.PushStyleColor(clr.ButtonActive, colorActive)
    if not size then size = imgui.ImVec2(0, 0) end
    local result = imgui.AnimatedButton(gg, size)
    imgui.PopStyleColor(3)
    return result
end
function imgui.CustomMenu(labels, selected, size, speed, centering)
    local bool = false
    speed = speed and speed or 0.2
    local radius = size.y * 0.50
    local draw_list = imgui.GetWindowDrawList()
    if LastActiveTime == nil then LastActiveTime = {} end
    if LastActive == nil then LastActive = {} end
    local function ImSaturate(f)
        return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
    end
    for i, v in ipairs(labels) do
        local c = imgui.GetCursorPos()
        local p = imgui.GetCursorScreenPos()
        if imgui.InvisibleButton(v..'##'..i, size) then
            selected.v = i
            LastActiveTime[v] = os.clock()
            LastActive[v] = true
            bool = true
        end
        imgui.SetCursorPos(c)
        local t = selected.v == i and 1.0 or 0.0
        if LastActive[v] then
            local time = os.clock() - LastActiveTime[v]
            if time <= 0.3 then
                local t_anim = ImSaturate(time / 0.2)
                t = selected.v == i and t_anim or 1.0 - t_anim
            else
                LastActive[v] = false
            end
        end
        local col_bg = imgui.GetColorU32(selected.v == i and imgui.GetStyle().Colors[imgui.Col.ButtonActive] or imgui.ImVec4(0,0,0,0))
        local col_box = imgui.GetColorU32(selected.v == i and imgui.GetStyle().Colors[imgui.Col.Button] or imgui.ImVec4(0,0,0,0))
        local col_hovered = imgui.GetStyle().Colors[imgui.Col.ButtonHovered]
        local col_hovered = imgui.GetColorU32(imgui.ImVec4(col_hovered.x, col_hovered.y, col_hovered.z, (imgui.IsItemHovered() and 0.2 or 0)))
        draw_list:AddRectFilled(imgui.ImVec2(p.x-size.x/6, p.y), imgui.ImVec2(p.x + (radius * 0.65) + t * size.x, p.y + size.y), col_bg, 10.0)
        draw_list:AddRectFilled(imgui.ImVec2(p.x-size.x/6, p.y), imgui.ImVec2(p.x + (radius * 0.65) + size.x, p.y + size.y), col_hovered, 10.0)
        draw_list:AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x+5, p.y + size.y), col_box)
        imgui.SetCursorPos(imgui.ImVec2(c.x+(centering and (size.x-imgui.CalcTextSize(v).x)/2 or 15), c.y+(size.y-imgui.CalcTextSize(v).y)/2))
        imgui.Text(v)
        imgui.SetCursorPos(imgui.ImVec2(c.x, c.y+size.y))
    end
    return bool
end

HeaderButton = function(bool, str_id)
    local DL = imgui.GetWindowDrawList()
    local ToU32 = imgui.ColorConvertFloat4ToU32
    local result = false
    local label = string.gsub(str_id, "##.*$", "")
    local duration = { 0.5, 0.3 }
    local cols = {
        idle = imgui.GetStyle().Colors[imgui.Col.Button],
        hovr = imgui.GetStyle().Colors[imgui.Col.Text],
        slct = imgui.GetStyle().Colors[imgui.Col.ButtonHovered]
    }

    if not AI_HEADERBUT then AI_HEADERBUT = {} end
     if not AI_HEADERBUT[str_id] then
        AI_HEADERBUT[str_id] = {
            color = bool and cols.slct or cols.idle,
            clock = os.clock() + duration[1],
            h = {
                state = bool,
                alpha = bool and 1.00 or 0.00,
                clock = os.clock() + duration[2],
            }
        }
    end
    local pool = AI_HEADERBUT[str_id]

    local degrade = function(before, after, start_time, duration)
        local result = before
        local timer = os.clock() - start_time
        if timer >= 0.00 then
            local offs = {
                x = after.x - before.x,
                y = after.y - before.y,
                z = after.z - before.z,
                w = after.w - before.w
            }

            result.x = result.x + ( (offs.x / duration) * timer )
            result.y = result.y + ( (offs.y / duration) * timer )
            result.z = result.z + ( (offs.z / duration) * timer )
            result.w = result.w + ( (offs.w / duration) * timer )
        end
        return result
    end

    local pushFloatTo = function(p1, p2, clock, duration)
        local result = p1
        local timer = os.clock() - clock
        if timer >= 0.00 then
            local offs = p2 - p1
            result = result + ((offs / duration) * timer)
        end
        return result
    end

    local set_alpha = function(color, alpha)
        return imgui.ImVec4(color.x, color.y, color.z, alpha or 1.00)
    end

    imgui.BeginGroup()
        local pos = imgui.GetCursorPos()
        local p = imgui.GetCursorScreenPos()
      
        imgui.TextColored(pool.color, label)
        local s = imgui.GetItemRectSize()
        local hovered = imgui.IsItemHovered()
        local clicked = imgui.IsItemClicked()
      
        if pool.h.state ~= hovered and not bool then
            pool.h.state = hovered
            pool.h.clock = os.clock()
        end
      
        if clicked then
            pool.clock = os.clock()
            result = true
        end

        if os.clock() - pool.clock <= duration[1] then
            pool.color = degrade(
                imgui.ImVec4(pool.color),
                bool and cols.slct or (hovered and cols.hovr or cols.idle),
                pool.clock,
                duration[1]
            )
        else
            pool.color = bool and cols.slct or (hovered and cols.hovr or cols.idle)
        end

        if pool.h.clock ~= nil then
            if os.clock() - pool.h.clock <= duration[2] then
                pool.h.alpha = pushFloatTo(
                    pool.h.alpha,
                    pool.h.state and 1.00 or 0.00,
                    pool.h.clock,
                    duration[2]
                )
            else
                pool.h.alpha = pool.h.state and 1.00 or 0.00
                if not pool.h.state then
                    pool.h.clock = nil
                end
            end

            local max = s.x / 2
            local Y = p.y + s.y + 3
            local mid = p.x + max

            DL:AddLine(imgui.ImVec2(mid, Y), imgui.ImVec2(mid + (max * pool.h.alpha), Y), ToU32(set_alpha(pool.color, pool.h.alpha)), 3)
            DL:AddLine(imgui.ImVec2(mid, Y), imgui.ImVec2(mid - (max * pool.h.alpha), Y), ToU32(set_alpha(pool.color, pool.h.alpha)), 3)
        end

    imgui.EndGroup()
    return result
end
function imgui.InputTextWithHint(label, hint, buf, flags, callback, user_data)
    local l_pos = {imgui.GetCursorPos(), 0}
    local handle = imgui.InputText(label, buf, flags, callback, user_data)
    l_pos[2] = imgui.GetCursorPos()
    local t = (type(hint) == 'string' and buf.v:len() < 1) and hint or '\0'
    local t_size, l_size = imgui.CalcTextSize(t).x, imgui.CalcTextSize('A').x
    imgui.SetCursorPos(imgui.ImVec2(l_pos[1].x + 8, l_pos[1].y + 2))
    imgui.TextDisabled((imgui.CalcItemWidth() and t_size > imgui.CalcItemWidth()) and t:sub(1, math.floor(imgui.CalcItemWidth() / l_size)) or t)
    imgui.SetCursorPos(l_pos[2])
    return handle
end
function imgui.TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.Text(u8(w)) end
        end
    end

    render_text(text)
end
function imgui.CenterTextColoredRGB(text)
    local width = imgui.GetWindowWidth()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local textsize = w:gsub('{.-}', '')
            local text_width = imgui.CalcTextSize(u8(textsize))
            imgui.SetCursorPosX( width / 2 - text_width .x / 2 )
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else
                imgui.Text(u8(w))
            end
        end
    end
    render_text(text)
end


apply_custom_style()