script_name("Doctor Helper")
script_version_number(2)
script_version("0.0.2")
local sampev = require 'lib.samp.events'
local imgui = require 'imgui'
local key = require 'vkeys'
local pie = require 'imgui_piemenu(new)'
encoding                        = require 'encoding'
encoding.default                    = 'CP1251'
u8                            = encoding.UTF8
local fa = require 'fAwesome5'
local res, https = pcall(require, 'ssl.https')
local nstatus, notf = pcall(import, "notifications_edit.lua")
local main_window = imgui.ImBool(false)
local menu_rp = imgui.ImBool(false)
local showPie = imgui.ImBool(true)
local playertarget = 0
local targetnamesave = 0
local otgr = 0
local UpdateBinder = false
local checkupd = true
local win_state = {}
win_state['update'] = imgui.ImBool(false)
local checkspawn = 0
local jsn_upd = "https://gitlab.com/snippets/1978930/raw"
local fa_font = nil
local CheckPlayer = 0
local pie_keyid = 1 -- 0 ЛКМ, 1 ПКМ, 2 СКМ
local pie_elements =
{
  {name = 'Медицинская карта', action = function() sampProcessChatInput('/medcard '..playertarget) CheckPlayer = 0 end, next = nil},
  {name = 'Укол/Вакцина', action = function() sampProcessChatInput('/vac '..playertarget) CheckPlayer = 0 end, next = nil},
  {name = 'Для старшего состава', action = function() end, next = {
    {name = 'Пригласить в организацию', action = function() CheckPlayer = 0 end, next = nil},
    {name = 'Повысить/Понизить должность', action = function() sampSendChat('Ку-ку.') CheckPlayer = 0 end, next = nil},
    {name = 'Уволить из фракции', action = function() sampSendChat('Дароу.') CheckPlayer = 0 end, next = nil}
  }}
}
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })
local randomid = 0
local generatedName = ''
function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig() 
        font_config.MergeMode = true

        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 13.0, font_config, fa_glyph_ranges)
    end
end
function imgui.OnDrawFrame()
	local x, y = getScreenResolution()
	if CheckPlayer == 1 then
		if showPie.v then
			if imgui.IsMouseClicked(pie_keyid) then imgui.OpenPopup('PieMenu') end
			if pie.BeginPiePopup('PieMenu', pie_keyid) then
			  for k, v in ipairs(pie_elements) do
				if v.next == nil then if pie.PieMenuItem(u8(v.name)) then v.action() end
				elseif type(v.next) == 'table' then drawPieSub(v) end
			  end
			  pie.EndPiePopup()
			end
		end
	end
	if menu_rp.v then
		imgui.SetNextWindowPos(imgui.ImVec2(x / 2, y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(300, 300), imgui.Cond.FirstUseEver)
		imgui.Begin(u8'Меню отыгровок '..fa.ICON_FA_AMBULANCE, menu_rp, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		local btn_size = imgui.ImVec2(-0.1, 0)
		imgui.ShowCursor = true
		if imgui.DegradeButton(u8'Закрытый перелом конечности', btn_size) then
			lua_thread.create(function()
			menu_rp.v = false
			sampSendChat('/do Медицинская сумка на плече.')
			wait(2000)
			sampSendChat('/me снял медицинскую сумку с плеча, затем открыл её')
			wait(2000)
			sampSendChat('/do В сумке лежат: стерильные шприцы, ампула с анальгетиком, шина, бинты.')
			wait(2000)
			sampSendChat('/me перелил содержимое ампулы в шприц')
			wait(2000)
			sampSendChat('/me закатал рукав пострадавшего, после чего ввёл анальгетик через шприц в вену, вдавив поршень')
			wait(2000)
			sampSendChat('/do Анальгетик проник в организм пострадавшего.')
			wait(2000)
			sampSendChat('/me выбросил использованный шприц')
			wait(2000)
			sampSendChat('/me достал из сумки шину, затем принялся накладывать её на повреждённую конечность')
			wait(2000)
			sampSendChat('/me аккуратно наложил шину на повреждённую конечность')
			wait(2000)
			sampSendChat('/do Шина качественно наложена на повреждённую конечность.')
			wait(2000)
			sampSendChat('/me взял из сумки стерильные бинты, затем начал делать косынку')
			wait(2000)
			sampSendChat('/me сделал косынку из стерильного бинта')
			wait(2000)
			sampSendChat('/me подвесил повреждённую конечность в согнутом положении')
			wait(2000)
			sampSendChat('/do Повреждённая конечность иммобилизована.')
			end)
		end
		if imgui.DegradeButton(u8'Открытый перелом конечности', btn_size) then
			lua_thread.create(function()
			menu_rp.v = false
			sampSendChat('/do Медицинская сумка на плече.')
			wait(2000)
			sampSendChat('/me снял медицинскую сумку с плеча, затем открыл её')
			wait(2000)
			sampSendChat('/do В сумке лежат: стерильные шприцы, ампула с анальгетиком, шина, бинты, антисептик и жгут.')
			wait(2000)
			sampSendChat('/me достал стерильный шприц с ампулой, аккуратно приоткрыв ампулу с анальгетиком')
			wait(2000)
			sampSendChat('/me перелил содержимое ампулы в шприц')
			wait(2000)
			sampSendChat('/me закатал рукав пострадавшего, после чего ввёл анальгетик через шприц в вену, вдавив поршень')
			wait(2000)
			sampSendChat('/do Анальгетик проник в организм пострадавшего.')
			wait(2000)
			sampSendChat('/me выбросил использованный шприц')
			wait(2000)
			sampSendChat('/me достал из сумки кровоостанавливающий жгут, затем начал накладывать его')
			wait(2000)
			sampSendChat('/me наложил жгут поверх раны на повреждённую конечность')
			wait(2000)
			sampSendChat('/me достал из сумки спрей с антисептическим средством')
			wait(2000)
			sampSendChat('/me обработал рану антисептическим средством')
			wait(2000)
			sampSendChat('/me убрал спрей в сумку и достал шину')
			wait(2000)
			sampSendChat('/me принялся накладывать её на повреждённую конечность')
			wait(2000)
			sampSendChat('/me аккуратно наложил шину на повреждённую конечность')
			wait(2000)
			sampSendChat('/do Шина качественно наложена на повреждённую конечность.')
			wait(2000)
			sampSendChat('/me взял из сумки стерильные бинты, затем начал делать косынку')
			wait(2000)
			sampSendChat('/me сделал косынку из стерильного бинта')
			wait(2000)
			sampSendChat('/me подвесил повреждённую конечность в согнутом положении')
			wait(2000)
			sampSendChat('/do Повреждённая конечность иммобилизована.')
			end)
		end
		if imgui.DegradeButton(u8'Измерение давления', btn_size) then
			lua_thread.create(function()
			menu_rp.v = false
			sampSendChat('/do Пациент сидит на кушетке.')
			wait(2000)
			sampSendChat('/do На столике рядом с кушеткой лежит сфигмоманометр.')
			wait(2000)
			sampSendChat('/me взял сфигмоманометр в правую руку и нацепил манжетку на левую руку пациента')
			wait(2000)
			sampSendChat('/do Манжетка находится на руке пациента.')
			wait(2000)
			sampSendChat('/me зафиксировал манжетку с помощью лепучек')
			wait(2000)
			sampSendChat('/me начал сжимать нагнетатель воздуха, тем самым накачивая манжетку')
			wait(2000)
			sampSendChat('/do Через некоторое время манометр показал результат измерения давления.')
			wait(2000)
			sampSendChat('/me нажал на клапан, который находится на нагнетателе, тем самым выпустив воздух')
			wait(2000)
			sampSendChat('/me расстегнул липучку на манжетке, после чего снял её, а затем положил на стол')
			wait(2000)
			sampSendChat('/do Сфигмоманометр лежит на тумбочке.')
			end)
		end
		if imgui.DegradeButton(u8'Операция по смене пола', btn_size) then
			lua_thread.create(function()
			main_window.v = false
			sampSendChat('/do Пациент лежит на операционном столе.')
			wait(2000)
			sampSendChat('/do Над столом висит маска аппарата для наркоза')
			wait(2000)
			sampSendChat('/me снял маску с крепления и вытянул шланг')
			wait(2000)
			sampSendChat('/me нажал на кнопку "ON" на пульте управления')
			wait(2000)
			sampSendChat('/do Пациент уснул.')
			wait(2000)
			sampSendChat('/me снял одежду с пациента')
			wait(2000)
			sampSendChat('/me открыл шкаф и повесил одежду больного')
			wait(2000)
			sampSendChat('/do На столе рядом со шкафом лежит белая накидка')
			wait(2000)
			sampSendChat('/me взял накидку и накрыл пациента')
			wait(2000)
			sampSendChat('/do В накидке подготовлено место оперирования.')
			wait(2000)
			sampSendChat('/do На держателе лежит бритва.')
			wait(2000)
			sampSendChat('/me взял бритву и начал сбривать волосы в паху и на мошонке')
			wait(2000)
			sampSendChat('/do На столе лежит пачка спиртовых салфеток.')
			wait(2000)
			sampSendChat('/me взял салфетку и вытер область паха пациента')
			wait(2000)
			sampSendChat('/me взял бинт со стола')
			wait(2000)
			sampSendChat('/me прибинтовал пенис к животу пациента')
			wait(2000)
			sampSendChat('/me положил бинт на место и взял скальпель')
			wait(2000)
			sampSendChat('/me сделал надрез по мошоночному шву')
			wait(2000)
			sampSendChat('/me достал изо шва правое яичко с семенным канатиком')
			wait(2000)
			sampSendChat('/me пережал семенной канатик и перерезал его')
			wait(2000)
			sampSendChat('/me сделал второй надрез по мошоночному шву')
			wait(2000)
			sampSendChat('/me достал изо шва левое яичко с семенным канатиком')
			wait(2000)
			sampSendChat('/me осторожным движением срезал мошонку')
			wait(2000)
			sampSendChat('/me сделал надрез пениса')
			wait(2000)
			sampSendChat('/me скальпелем преобразовал покровы пениса в стенки нео-вагины')
			wait(2000)
			sampSendChat('/me скальпелем преобразовал часть головки пениса в нео-клитор')
			wait(2000)
			sampSendChat('/me укоротил уретру')
			wait(2000)
			sampSendChat('/me сформировал малые половые губы из тканей пениса')
			wait(2000)
			sampSendChat('/me сформировал большие половые губы из кожи мошонки')
			wait(2000)
			sampSendChat('/me сделал небольшой надрез в области паха')
			wait(2000)
			sampSendChat('/me разместил новые органы на своем месте')
			wait(2000)
			sampSendChat('/me положил скальпель и взял иглу')
			wait(2000)
			sampSendChat('/me наложил швы на каналы и разрезы')
			wait(2000)
			sampSendChat('/me нажал кнопку "OFF" на пульте управления')
			wait(2000)
			sampSendChat('/do Пациент проснулся.')
			end)
		end
		if imgui.DegradeButton(u8'Ушибы/Растяжения', btn_size) then
			lua_thread.create(function()
			menu_rp.v = false
			sampSendChat('/do На правом плече висит медицинская сумка.')
			wait(2000)
			sampSendChat('/me открыв мед. сумку, достал из неё эластичный бинт')
			wait(2000)
			sampSendChat('/me достав из сумки спрей «Фрост», обработал ушиб спреем')
			wait(2000)
			sampSendChat('/me убрав спрей в сумку, наложил на конечность пострадавшего эластичных бинт')
			wait(2000)
			sampSendChat('/me крепко затянул эластичный бинт')
			wait(2000)
			sampSendChat('/do Эластичный бинт плотно сидит на конечности пациента.')
			end)
		end
		--imgui.Text(u8"\n\n\n\n\n\n\t\t\t\t\t\t\t\tver."..thisScript().version)
		--[[if imgui.InvButton(u8"ver."..thisScript().version, imgui.ImVec2(0, -4)) then
			sampAddChatMessage('Хорошая работа, алег...')
		end]]
		if tonumber(thisScript().version_num) <= dropver then
			if imgui.InvButton(fa.ICON_FA_EXCLAMATION_CIRCLE, imgui.ImVec2(0, 0)) then
				autoupdate(jsn_upd)
			end
		elseif version > tonumber(thisScript().version_num) then
			if imgui.InvButton(fa.ICON_FA_CLOUD_UPLOAD_ALT, imgui.ImVec2(0, 0)) then
				autoupdate(jsn_upd)
			end
		else
			if imgui.InvButton(fa.ICON_FA_CHECK_CIRCLE, imgui.ImVec2(0, 0)) then
				autoupdate(jsn_upd)
			end
		end
		imgui.End()
	end
end

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end
	update()
	while not UpdateBinder do wait(0) end
	sampRegisterChatCommand('m', function() menu_rp.v = not menu_rp.v end)
	sampRegisterChatCommand("invite", invite)
	sampRegisterChatCommand("medcard", medcard)
	sampRegisterChatCommand("vac", vac)
	while true do
		wait(0)
		--[[if sampIsLocalPlayerSpawned() then
			if checkspawn == 0 then
				notf.addNotification('Привет!\nХорошего рабочего дня!', 3, 5, 10)
				checkspawn = 1
			end
		end]]
		if wasKeyPressed(key.VK_B) then
			if sampIsChatInputActive() == true then return false end
			if sampIsDialogActive() == true then return false end
			menu_rp.v = not menu_rp.v
		end
		if (wasKeyPressed(key.VK_Z) and wasKeyPressed(key.VK_RBUTTON)) then
			if sampIsChatInputActive() == true then return false end
			if sampIsDialogActive() == true then return false end
			local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
			name = sampGetPlayerNickname(myid)
			lol = string.gsub (name, '_', ' ', 1)
			sampSendChat('Здравствуйте, я Ваш лечащий врач '..lol..', что Вас беспокоит?') 
		end
		local chas = tonumber(os.date("%H"))
		local minute = tonumber(os.date("%M"))
		local sec = tonumber(os.date("%S"))
		if (minute == 55) and (sec == 00) then
			if nstatus then
				notf.addNotification('До зарплаты осталось 5 минут.', 10, 5, 10)
				wait(1000)
			end
		end
		if (chas == 19) and (minute == 30) and (sec == 0) then
			if nstatus then
				notf.addNotification('До конца рабочего дня осталось 30 минут.', 10, 5, 10)
				wait(1000)
			end
		end
		if (chas == 20) and (minute == 00) and (sec == 0) then
			if nstatus then
				notf.addNotification('Рабочий день окончен!\nХорошего Вам отдыха!', 10, 5, 10)
				wait(1000)
			end
		end
		local result, target = getCharPlayerIsTargeting(playerHandle)
		if result then result, playerid = sampGetPlayerIdByCharHandle(target) end
		if result and wasKeyPressed(key.VK_X) then
			name = sampGetPlayerNickname(playerid)
			playertarget = playerid
			targetnamesave = name
			sampSendChat('/todo Хорошо, я вас услышал.*улыбнувшись')
			wait(500)
			sampSendChat('/do Медицинский кейс с принадлежностями в руке.')
			wait(500)
			sampSendChat('/me открыл кейс и из нижнего отсека достал пачку с таблетками')
			wait(500)
			sampSendChat('/me открыв пачку, достал оттуда блистер')
			wait(500)
			sampSendChat('/me вытащил бутылку с водой и связку пластмассовых стаканчиков')
			wait(500)
			sampSendChat('/me выдавив таблетку из блистера, вытащил один стаканчик и налил туда воды')
			wait(500)
			sampSendChat('/todo Вот, выпейте, пожалуйста.*передал стаканчик и таблетку пациенту')
			wait(500)
			sampSendChat('/heal '..playertarget..' 125')
		end
		if result and wasKeyPressed(key.VK_Q) then
			name = sampGetPlayerNickname(playerid)
			playertarget = playerid
			sampAddChatMessage('{800C8D}[Doctor Helper]{F0D500} Вы выбрали цель: {800C8D}'..name..'. {F0D500}Чтобы отключить меню нажмите: {800C8D}"Delete".', 0x046D63)
			CheckPlayer = 1
		end
		imgui.ShowCursor = false
		if CheckPlayer == 1 and wasKeyPressed(key.VK_DELETE) then CheckPlayer = 0 end
		if CheckPlayer == 1 then imgui.ShowCursor = (showPie.v and imgui.IsMouseDown(1)) end
		imgui.Process = main_window.v or menu_rp.v or showPie.v
	end
end
-----------------------------------------------------------------[Обновление]-------------------------------------------------------------
function update() 
	local zapros = https.request("https://raw.githubusercontent.com/Friendly595/doctorhelper/script/update.json")

	if zapros ~= nil then
		local info2 = decodeJson(zapros)

		if info2.latest_number ~= nil and info2.latest ~= nil and info2.drop ~= nil then
			updatever = info2.latest
			version = tonumber(info2.latest_number)
			dropver = tonumber(info2.drop)
			
			if tonumber(thisScript().version_num) <= dropver then
				print("[Update] Used non supported version: "..thisScript().version_num..", actual: "..version)
				sampAddChatMessage("{800C8D}[Doctor Helper]{F0D500} Ваша версия более не поддерживается разработчиком, работа скрипта невозможна.", 0x046D63)
				reloadScript = true
				thisScript():unload()
			elseif version > tonumber(thisScript().version_num) then
				print("[Update] Обнаружено обновление")
				sampAddChatMessage("{800C8D}[Doctor Helper]{F0D500} Обнаружено обновление до версии {800C8D}"..updatever..".", 0x046D63)
				win_state['update'].v = true
				UpdateBinder = true
			else
				print("[Update] Новых обновлений нет, контроль версий пройден")
				if checkupd then
					sampAddChatMessage("{800C8D}[Doctor Helper]{F0D500} У вас стоит актуальная версия скрипта: {800C8D}"..thisScript().version..". {F0D500}Приятного пользования.", 0x046D63)
					checkupd = false
				end
				UpdateBinder = true
			end
		else
			sampAddChatMessage("{800C8D}[Doctor Helper]{F0D500} Ошибка при получении информации об обновлении.", 0x046D63)
			print("[Update] JSON file read error")
			UpdateBinder = true
		end
	else
		sampAddChatMessage("{800C8D}[Doctor Helper]{F0D500} Не удалось проверить наличие обновлений, попробуйте позже.", 0x046D63)
		UpdateBinder = true
	end
end
function autoupdate(json_url)
	local dlstatus = require('moonloader').download_status
	local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
	if doesFileExist(json) then os.remove(json) end
	sampAddChatMessage('{800C8D}[Doctor Helper]{F0D500} Начало проверки обновления')
	downloadUrlToFile(json_url, json,
		function(id, status, p1, p2)
			if status == dlstatus.STATUSEX_ENDDOWNLOAD then
			if doesFileExist(json) then
				local f = io.open(json, 'r')
				if f then
					local info = decodeJson(f:read('*a'))
					updatelink = info.updateurl
					updateversion = info.latest
					f:close()
					os.remove(json)
					if updateversion ~= thisScript().version then
						lua_thread.create(function()
							local dlstatus = require('moonloader').download_status
							local color = -1
							sampAddChatMessage('{800C8D}[Doctor Helper]{F0D500} Найдено обновление: '..thisScript().version..' -> '..updateversion..'! Загрузка..')
							wait(250)
							downloadUrlToFile(updatelink, thisScript().path,
								function(id3, status1, p13, p23)
									if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
									elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
										sampAddChatMessage('{800C8D}[Doctor Helper]{F0D500} Загрузка окончена. Скрипт обновлен на версию '..mc..updateversion)
										goupdatestatus = true

										local v1 = updateversion:match('^(%d+)')
										local v2 = thisScript().version:match('^(%d+)')
										if v1 ~= v2 then
											cfg.main.infoupdate = true
										end

										reload(false)
									end
									if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
										if goupdatestatus == nil then
											sampAddChatMessage('{800C8D}[Doctor Helper]{F0D500} Скрипт не смог обновится на версию '..updateversion)
											update = false
										end
									end
								end
							)   
						end)
					else
						update = false
						sampAddChatMessage('{800C8D}[Doctor Helper]{F0D500} Версии совпадают. Обновлений нет')
						sampAddChatMessage('{800C8D}[Doctor Helper]{F0D500} Обновлений не найдено')
					end
				end
			else
				sampAddChatMessage('{800C8D}[Doctor Helper]{F0D500} Не удалось получить JSON таблицу', 0xFF0000)
				sampAddChatMessage('{800C8D}[Doctor Helper]{F0D500} Обновление не удалось')
				update = false
			end
		end
	end)
	lua_thread.create(function()
	while update ~= false do 
		wait(100) 
	end
	end)
end
-----------------------------------------------------------------[Команды]-------------------------------------------------------------
function invite(params)
    lua_thread.create(function()
        id = tonumber(params)
		if params and id~=nil then
			sampSendChat("/me засунул руку в правый карман и достал телефон")
			wait(2000)
			sampSendChat("/me открыл приложение: «Организации», затем нажал на кнопку: «Сотрудники»")
			wait(2000)
			sampSendChat("/me ввёл имя и фамилию, а затем нажал на кнопку: «Добавить»")
			wait(2000)
			sampSendChat("/invite " ..id)
			wait(2000)
			sampSendChat("/me заблокировал экран и положил телефон в правый карман")
		end
    end)
end

function medcard(params)
    lua_thread.create(function()
        id = tonumber(params)
		if params and id~=nil then
			sampSendChat('/todo Так-с, что тут у нас.*взяв документы о состоянии здоровья пациента.')
			wait(2000)
			sampSendChat('/do Вся собранная информация о состоянии здоровья пациента в руках доктора.')
			wait(2000)
			sampSendChat('/me изучил необходимые данные и положил документы на стол')
			wait(2000)
			sampSendChat('/do На столе лежат незаполненные бланки медицинских карт и чёрная ручка.')
			wait(2000)
			sampSendChat('/me взял ручку в руку, скинув колпачок и отделив один бланк из стопки')
			wait(2000)
			sampSendChat('/me открыл первую страницу в документах и начал заполнять бланк карты')
			wait(2000)
			sampSendChat('/do Спустя несколько минут практически все данные были внесены.')
			wait(2000)
			sampSendChat('/do В самом конце бланка осталась графа «Перенесённые заболевания». ')
			wait(2000)
			sampSendChat('/me развернул документы о состоянии здоровья на последней странице')
			wait(2000)
			sampSendChat('/me начал переписывать перечень болезней')
			wait(2000)
			sampSendChat('/me переписал все болезни и проверил их корректность и количество')
			wait(2000)
			sampSendChat('/do Все данные совпадали.')
			wait(2000)
			sampSendChat('/me перевернул бланк, глазами ища место для печати и подписи врача')
			wait(2000)
			sampSendChat('/me осмотрел стол и, немного пробежавшись глазами, нашёл печатку')
			wait(2000)
			sampSendChat('/me взял её в руки и, открыв, аккуратно приложил к нужному месту на карте')
			wait(2000)
			sampSendChat('/do Печать была поставлена.')
			wait(2000)
			sampSendChat('/me указал дату и подпись, после чего перевернул карту и вручил её пациенту')
			wait(2000)
			sampSendChat('/do Медицинская карта выдана.')
			wait(2000)
			sampSendChat('/medcard '..id)
		end
    end)
end

function vac(params)
    lua_thread.create(function()
        id = tonumber(params)
		if params and id~=nil then
			sampSendChat("/me достал пачку шприцов из ящика, предварительно открыв её")
			wait(2000)
			sampSendChat("/me достал шприц из пачки, затем взяв со стола ампулу с вакциной")
			wait(2000)
			sampSendChat("/me продезинфицировал руки специальным средством")
			wait(2000)
			sampSendChat("/me взял со стола ватку и спирт, затем открыл флакончик и смочил ватку спиртом")
			wait(2000)
			sampSendChat("/me взял со стола медицинские перчатки, надел их на руки")
			wait(2000)
			sampSendChat("/me вколол шприц с вакциной в вену человека")
			wait(2000)
			sampSendChat("/me нажимает на клапан шприца, тем самым вгоняет содержимое в вену")
			wait(2000)
			sampSendChat("/vac "..id)
		end
    end)
end
-------------------------------------------------------------------------------------------------------------------------------------
function sampev.onServerMessage(color, text)
	local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	name = sampGetPlayerNickname(myid)
	if text:find('повысил Вас') then
		notf.addNotification('Поздравляем!\nВас повысили в должности! Двигайтесь в том же духе!', 10, 5, 10)
	end
	if text:find('не нуждается в вакцинации') then
		notf.addNotification('Ошибка! Игрок не нуждается в вакцинации!', 10, 0, 10)
	end
	if text:find('есть мед.карта') then
		notf.addNotification('Ошибка! У игрока уже есть мед.карта!', 10, 0, 10)
	end
	if text:find('Медицинская карта продана') then
		notf.addNotification('Вы выдали мед.карту', 3, 5, 10)
	end
	if text:find('Пациент согласился на лечение') then
		notf.addNotification('Вы вылечили '..targetnamesave, 3, 5, 5)
	end
end

function imgui.DegradeButton(label, size)
    local duration = {
        1.0, 
        0.3  
    }

    local cols = {
        default = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.Button]),
        hovered = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.ButtonHovered]),
        active  = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.ButtonActive])
    }

    if not FBUTPOOL then FBUTPOOL = {} end
    if not FBUTPOOL[label] then
        FBUTPOOL[label] = {
            color = cols.default,
            clicked = { nil, nil },
            hovered = {
                cur = false,
                old = false,
                clock = nil,
            }
        }
    end

    local degrade = function(before, after, start_time, duration)
        local result_vec4 = before
        local timer = os.clock() - start_time
        if timer >= 0.00 then
            local offs = {
                x = after.x - before.x,
                y = after.y - before.y,
                z = after.z - before.z,
                w = after.w - before.w
            }

            result_vec4.x = result_vec4.x + ( (offs.x / duration) * timer )
            result_vec4.y = result_vec4.y + ( (offs.y / duration) * timer )
            result_vec4.z = result_vec4.z + ( (offs.z / duration) * timer )
            result_vec4.w = result_vec4.w + ( (offs.w / duration) * timer )
        end
        return result_vec4
    end

    if FBUTPOOL[label]['clicked'][1] and FBUTPOOL[label]['clicked'][2] then
        if os.clock() - FBUTPOOL[label]['clicked'][1] <= duration[2] then
            FBUTPOOL[label]['color'] = degrade(
                FBUTPOOL[label]['color'],
                cols.active,
                FBUTPOOL[label]['clicked'][1],
                duration[2]
            )
            goto no_hovered
        end

        if os.clock() - FBUTPOOL[label]['clicked'][2] <= duration[2] then
            FBUTPOOL[label]['color'] = degrade(
                FBUTPOOL[label]['color'],
                FBUTPOOL[label]['hovered']['cur'] and cols.hovered or cols.default,
                FBUTPOOL[label]['clicked'][2],
                duration[2]
            )
            goto no_hovered
        end
    end

    if FBUTPOOL[label]['hovered']['clock'] ~= nil then
        if os.clock() - FBUTPOOL[label]['hovered']['clock'] <= duration[1] then
            FBUTPOOL[label]['color'] = degrade(
                FBUTPOOL[label]['color'],
                FBUTPOOL[label]['hovered']['cur'] and cols.hovered or cols.default,
                FBUTPOOL[label]['hovered']['clock'],
                duration[1]
            )
        else
            FBUTPOOL[label]['color'] = FBUTPOOL[label]['hovered']['cur'] and cols.hovered or cols.default
        end
    end

    ::no_hovered::

    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(FBUTPOOL[label]['color']))
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(FBUTPOOL[label]['color']))
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(FBUTPOOL[label]['color']))
    local result = imgui.Button(label, size or imgui.ImVec2(0, 0))
    imgui.PopStyleColor(3)

    if result then
        FBUTPOOL[label]['clicked'] = {
            os.clock(),
            os.clock() + duration[2]
        }
    end

    FBUTPOOL[label]['hovered']['cur'] = imgui.IsItemHovered()
    if FBUTPOOL[label]['hovered']['old'] ~= FBUTPOOL[label]['hovered']['cur'] then
        FBUTPOOL[label]['hovered']['old'] = FBUTPOOL[label]['hovered']['cur']
        FBUTPOOL[label]['hovered']['clock'] = os.clock()
    end

    return result
end
function imgui.InvButton(text, size)
    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0, 0, 0, 0))
         local button = imgui.Button(text, size)
    imgui.PopStyleColor(3)
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
		if tonumber(thisScript().version_num) <= dropver then imgui.TextUnformatted(u8'Данная версия скрипта больше не поддерживается разработчиком.\nЧтобы установить новую версия, нажмите на значок.')
		elseif version > tonumber(thisScript().version_num) then imgui.TextUnformatted(u8'Доступно новое обновление!\nЧтобы обновить скрипт до актуальной версии, нажмите на значок.')
		else imgui.TextUnformatted(u8'У Вас установлена актуальная версия скрипта.') end
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
    return button
end
function drawPieSub(v)
  if pie.BeginPieMenu(u8(v.name)) then
    for i, l in ipairs(v.next) do
      if l.next == nil then
        if pie.PieMenuItem(u8(l.name)) then l.action() end
      elseif type(l.next) == 'table' then
        drawPieSub(l)
      end
    end
    pie.EndPieMenu()
  end
end

imgui.SwitchContext()
local style = imgui.GetStyle()
local colors = style.Colors
local clr = imgui.Col
local ImVec4 = imgui.ImVec4
local ImVec2 = imgui.ImVec2

style.WindowPadding = ImVec2(15, 15)
style.WindowRounding = 15.0
style.FramePadding = ImVec2(5, 5)
style.ItemSpacing = ImVec2(12, 8)
style.ItemInnerSpacing = ImVec2(8, 6)
style.IndentSpacing = 25.0
style.ScrollbarSize = 15.0
style.ScrollbarRounding = 15.0
style.GrabMinSize = 15.0
style.GrabRounding = 7.0
style.ChildWindowRounding = 8.0
style.FrameRounding = 6.0


colors[clr.Text] = ImVec4(0.95, 0.96, 0.98, 1.00)
colors[clr.TextDisabled] = ImVec4(0.36, 0.42, 0.47, 1.00)
colors[clr.WindowBg] = ImVec4(0.11, 0.15, 0.17, 1.00)
colors[clr.ChildWindowBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.FrameBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
colors[clr.FrameBgHovered] = ImVec4(0.12, 0.20, 0.28, 1.00)
colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1.00)
colors[clr.TitleBg] = ImVec4(0.09, 0.12, 0.14, 0.65)
colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
colors[clr.TitleBgActive] = ImVec4(0.61, 0.16, 0.39, 1.00)
colors[clr.MenuBarBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.39)
colors[clr.ScrollbarGrab] = ImVec4(0.20, 0.25, 0.29, 1.00)
colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
colors[clr.ScrollbarGrabActive] = ImVec4(0.09, 0.21, 0.31, 1.00)
colors[clr.ComboBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
colors[clr.CheckMark] = ImVec4(0.28, 0.56, 1.00, 1.00)
colors[clr.SliderGrab] = ImVec4(0.28, 0.56, 1.00, 1.00)
colors[clr.SliderGrabActive] = ImVec4(0.37, 0.61, 1.00, 1.00)
colors[clr.Button] = ImVec4(0.20, 0.25, 0.29, 1.00)
colors[clr.ButtonHovered] = ImVec4(0.69, 0.17, 0.43, 1.00)
colors[clr.ButtonActive] = ImVec4(0.59, 0.10, 0.35, 1.00)
colors[clr.Header] = ImVec4(0.20, 0.25, 0.29, 0.55)
colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)


HeaderButton = function(bool, str_id)
    local DL = imgui.GetWindowDrawList()
    local ToU32 = imgui.ColorConvertFloat4ToU32
    local result = false
    local label = string.gsub(str_id, "##.*$", "")
    local duration = { 0.5, 0.3 }
    local cols = {
        idle = imgui.GetStyle().Colors[imgui.Col.TextDisabled],
        hovr = imgui.GetStyle().Colors[imgui.Col.Text],
        slct = imgui.GetStyle().Colors[imgui.Col.ButtonActive]
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