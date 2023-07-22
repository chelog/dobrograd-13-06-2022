simfphys.attachments = {

	siren1 = {
		type = 'siren',
		mdl = 'models/octocar/police_siren.mdl',
	},

	siren2 = {
		type = 'siren',
		mdl = 'models/octocar/police_siren2.mdl',
	},

	siren3 = {
		type = 'siren',
		mdl = 'models/jaanus/wiretool/wiretool_siren.mdl',
		name = 'Проблесковый маячок', mass = 5, volume = 12,
		desc = 'Используется',
		col = Color(0,0,127),
		noPaint = true,
	},

	spoiler1 = {
		type = 'spoiler',
		name = L.spoiler1, mass = 5, volume = 12,
		desc = L.desc_spoiler1,
		mdl = 'models/octocar/attachable/spoiler1.mdl',
	},

	spoiler2 = {
		type = 'spoiler',
		mdl = 'models/octocar/attachable/spoiler2.mdl',
		name = L.spoiler2, mass = 5, volume = 12,
		desc = L.desc_spoiler2,
	},

	spoiler3 = {
		type = 'spoiler',
		mdl = 'models/octocar/attachable/spoiler3.mdl',
		name = L.spoiler3, mass = 5, volume = 12,
		desc = L.desc_spoiler3,
	},

	spoiler4 = {
		type = 'spoiler',
		mdl = 'models/octocar/attachable/spoiler4.mdl',
		name = L.spoiler4, mass = 5, volume = 12,
		desc = L.desc_spoiler4,
	},

	spoiler5 = {
		type = 'spoiler',
		mdl = 'models/octocar/attachable/spoiler5.mdl',
		name = L.spoiler5, mass = 5, volume = 12,
		desc = L.desc_spoiler5,
	},

	ladder = {
		type = 'ladder',
		noPaint = true,
		mdl = 'models/octocar/attachable/ladder.mdl',
		name = L.ladder, mass = 3, volume = 8,
		desc = L.desc_ladder,
	},

	supercharger = {
		type = 'supercharger',
		mdl = 'models/octocar/attachable/supercharger.mdl',
		name = L.supercharger, mass = 10, volume = 10,
		desc = L.desc_supercharger,
	},

	huladoll = {
		type = 'dash',
		noPaint = true,
		mdl = 'models/props_lab/huladoll.mdl',
		name = L.huladoll, mass = 0.5, volume = 1,
		desc = L.desc_huladoll,
	},

	snowman = {
		type = 'dash',
		noPaint = true,
		mdl = 'models/unconid/xmas/snowman_u.mdl',
		name = 'Снеговичок на приборку', mass = 0.5, volume = 1,
		desc = 'Принесет новогоднее настроение в твой автомобиль',
	},

	skull = {
		type = 'other1',
		noPaint = true,
		mdl = 'models/gibs/hgibs.mdl',
		name = L.statuette_ermak, mass = 1, volume = 2,
		desc = L.desc_statuette_ermak,
	},

	pumpkin = {
		type = 'other2',
		noPaint = true,
		mdl = 'models/halloween2015/pumbkin_n_f01.mdl',
		skin = 1,
		scale = 0.2,
		name = L.lamp_pumpkin, mass = 1, volume = 3,
		desc = L.desc_lamp_pumpkin,
	},

	metalhook = {
		type = 'other3',
		noPaint = true,
		mdl = 'models/props_junk/meathook001a.mdl',
		name = L.car_hook, mass = 1, volume = 3,
		desc = L.desc_car_hook,
	},

	doll = {
		type = 'other4',
		noPaint = true,
		mdl = 'models/props_c17/doll01.mdl',
		name = L.scary_doll, mass = 1, volume = 3,
		desc = L.desc_scary_doll,
	},

	jar = {
		type = 'other5',
		noPaint = true,
		mdl = 'models/props/spookington/eyejar.mdl',
		name = 'Банка с глазами', mass = 3, volume = 1,
		desc = 'Масса взрослого человеческого глаза равна 7-8г',
	},

	spider = {
		type = 'other6',
		noPaint = true,
		mdl = 'models/props/spookington/spider_toy.mdl',
		name = 'Паучок', mass = 0.7, volume = 1,
		desc = 'Внутри забит поролоном, хотя... кто знает...',
	},

}

local attsByMdl = {}
for _, att in pairs(simfphys.attachments) do
	attsByMdl[att.mdl] = att
end

function simfphys.getAttByModel(mdl)
	return attsByMdl[mdl]
end

simfphys.rims = {
	['models/diggercars/250gto/250gto_wheel.mdl'] = {
		price = 150000,
		name = L.discs_hint .. 'Ferrari 250 GTO',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/356/porsche_550356_wheel.mdl'] = {
		price = 155000,
		name = L.discs_hint .. 'Porsche 356',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/914_6/porsche_914_wheel.mdl'] = {
		price = 80000,
		name = L.discs_hint .. 'Porsche 914',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/a_nsx97/wheel.mdl'] = {
		price = 95000,
		name = L.discs_hint .. 'Acura NSX 1997',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/alfa_romeo_montreal/wheel.mdl'] = {
		price = 168000,
		name = L.discs_hint .. 'Alfa Romeo Montreal',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/bmw_m5e28/wheel.mdl'] = {
		price = 150000,
		name = L.discs_hint .. 'BMW M5 E28',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/bmw_m5e39/wheel.mdl'] = {
		price = 135000,
		name = L.discs_hint .. 'BMW M5 E39',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/bmw_x5m/wheel.mdl'] = {
		price = 120000,
		name = L.discs_hint .. 'BMW X5 M',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/bmwm1/bmwm1_wheel.mdl'] = {
		price = 160000,
		name = L.discs_hint .. 'BMW M1',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/boxster03/wheel.mdl'] = {
		price = 100000,
		name = L.discs_hint .. 'Porsche Boxster 2003',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/civic94/wheel.mdl'] = {
		price = 95000,
		name = L.discs_hint .. 'Honda Civic 1994',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/fulvia/wheel.mdl'] = {
		price = 145000,
		name = L.discs_hint .. 'Lancia Fulvia',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/gt3 2004/wheel.mdl'] = {
		price = 110000,
		name = L.discs_hint .. 'Porsche GT3',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/h_nsxrgt/wheel.mdl'] = {
		price = 98000,
		name = L.discs_hint .. 'Honda NSX-R GT',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/legacy/wheel.mdl'] = {
		price = 85000,
		name = L.discs_hint .. 'Legacy',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/packcard/wheel.mdl'] = {
		price = 190000,
		name = L.discs_hint .. 'Packard',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/porsche_930/wheel.mdl'] = {
		price = 175000,
		name = L.discs_hint .. 'Porsche 930',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/porsche_930/wheelr.mdl'] = {
		price = 170000,
		name = L.discs_hint .. 'Porsche 930-2',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/991_carrera_s/wheel2.mdl'] = {
		price = 125000,
		name = L.discs_hint .. 'Porsche 991 Carrera S',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/porsche_930targa/wheel.mdl'] = {
		price = 140000,
		name = L.discs_hint .. 'Porsche 930 Targa',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/porsche_944/wheel.mdl'] = {
		price = 110000,
		name = L.discs_hint .. 'Porsche 944',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/shelbydaytonacoupe/wheel.mdl'] = {
		price = 165000,
		name = L.discs_hint .. 'Shelby Daytona',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/sportquattro/wheel.mdl'] = {
		price = 115000,
		name = L.discs_hint .. 'Audi Sport Quattro',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/stratos/wheel.mdl'] = {
		price = 165000,
		name = L.discs_hint .. 'Lancia Stratos',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/transam3/wheel.mdl'] = {
		price = 195000,
		name = L.discs_hint .. 'Firebird Transam3',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/a_nsx97/wheel2.mdl'] = {
		price = 148000,
		name = L.discs_hint .. 'Acura NSX 1997-2',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/a_nsx05/wheel.mdl'] = {
		price = 125000,
		name = L.discs_hint .. 'Acura NSX 2005',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/acura_rsxs/wheel.mdl'] = {
		price = 135000,
		name = L.discs_hint .. 'Acura RSXS',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/alfa/wheel.mdl'] = {
		price = 110000,
		name = L.discs_hint .. 'Alfa Romeo',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/ariel_atom/wheel.mdl'] = {
		price = 190000,
		name = L.discs_hint .. 'Ariel Atom',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/bmw_m5e34/wheel.mdl'] = {
		price = 120000,
		name = L.discs_hint .. 'BMW M5 E34',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/bmw_m5e60/wheel.mdl'] = {
		price = 110000,
		name = L.discs_hint .. 'BMW M5 E60',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/bmw_x5_09/wheel.mdl'] = {
		price = 140000,
		name = L.discs_hint .. 'BMW X5 2009',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/bmw_x5_09/wheel2.mdl'] = {
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/bmw_x6m/wheel.mdl'] = {
		price = 140000,
		name = L.discs_hint .. 'BMW X6 M',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/fiat500/wheel.mdl'] = {
		price = 90000,
		name = L.discs_hint .. 'Fiat 500',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/cortina/wheel.mdl'] = {
		price = 85000,
		name = L.discs_hint .. 'Ford Cortina',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/civic91/wheel.mdl'] = {
		price = 95000,
		name = L.discs_hint .. 'Honda Civic 1991',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/civic99/wheel.mdl'] = {
		price = 135000,
		name = L.discs_hint .. 'Honda Civic 1999',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/h_integra2000/wheel.mdl'] = {
		price = 115000,
		name = L.discs_hint .. 'Honda Integra 2000',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/h_integra/wheel.mdl'] = {
		price = 125000,
		name = L.discs_hint .. 'Honda Integra',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/h_nsxr/wheel.mdl'] = {
		price = 160000,
		name = L.discs_hint .. 'Honda NSX-R',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/aventador/wheel.mdl'] = {
		price = 190000,
		name = L.discs_hint .. 'Lamborghini Aventador',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/jalpa/wh1.mdl'] = {
		price = 175000,
		name = L.discs_hint .. 'Lamborghini Jalpa',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/300sl/wheel.mdl'] = {
		price = 185000,
		name = L.discs_hint .. 'Mercedes-Benz 300 SL',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/clkgtr/wheel.mdl'] = {
		price = 160000,
		name = L.discs_hint .. 'Mercedes-Benz CLK GTR',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/w123/mb_w123_wheel.mdl'] = {
		price = 165000,
		name = L.discs_hint .. 'Mercedes-Benz W123',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/opelspeedster/wheel.mdl'] = {
		price = 175000,
		name = L.discs_hint .. 'Opel Speedster',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/porsche_914/wheel.mdl'] = {
		price = 150000,
		name = L.discs_hint .. 'Porsche 914-2',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/959/porsche_959_wheel.mdl'] = {
		price = 165000,
		name = L.discs_hint .. 'Porsche 959',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/964speedster/porsche_964_wheel.mdl'] = {
		price = 175000,
		name = L.discs_hint .. 'Porsche 964',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/997 turbo/wheel.mdl'] = {
		price = 170000,
		name = L.discs_hint .. 'Porsche 997',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/carrera gt/wheel.mdl'] = {
		price = 188000,
		name = L.discs_hint .. 'Porsche Carrera GT',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/gt1sv/porsche_gt1_wheel.mdl'] = {
		price = 165000,
		name = L.discs_hint .. 'Porsche GT1',
		ang = Angle(0, -90, 0),
	},
	['models/diggercars/saab99turbo/wheel.mdl'] = {
		price = 175000,
		name = L.discs_hint .. 'Saab 99',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/toyotagtone/wheel.mdl'] = {
		price = 155000,
		name = L.discs_hint .. 'Toyota GT-One',
		ang = Angle(0, 90, 0),
	},
	['models/diggercars/vaz1111/oka_wheel.mdl'] = {
		price = 50000,
		name = L.discs_hint .. L.item_disc,
		ang = Angle(0, -90, 0),
	},
	['models/hl2prewar/hatch/hatch_v2_wheel.mdl'] = {
		price = 110000,
		name = L.discs_hint .. L.item_disc2,
	},
	['models/hl2prewar/van/van_wheel.mdl'] = {
		price = 22000,
		name = L.discs_hint .. L.item_disc3,
	},
	['models/salza/trabant/trabant_wheel.mdl'] = {
		price = 20000,
		name = L.discs_hint .. L.item_disc4,
	},
	['models/salza/volga/volga_wheel.mdl'] = {
		price = 15500,
		name = L.discs_hint .. L.item_disc5,
	},
	['models/salza/zaz/zaz_wheel.mdl'] = {
		price = 15000,
		name = L.discs_hint .. L.item_disc6,
	},
	['models/salza/hatchback/hatchback_wheel.mdl'] = {
		price = 12000,
		name = L.discs_hint .. L.item_disc7,
		ang = Angle(0, -90, 0),
	},
	['models/salza/avia/avia_wheel.mdl'] = {
		price = 10000,
		name = L.discs_hint .. L.item_disc8,
		ang = Angle(0, 180, 0),
	},
	['models/salza/skoda_liaz/skoda_liaz_fwheel.mdl'] = {
		price = 13500,
		name = L.discs_hint .. L.item_disc9,
		ang = Angle(0, 180, 0),
	},
	['models/props_phx/wheels/trucktire.mdl'] = {
		price = 80000,
		name = L.discs_hint .. L.item_disc10,
		ang = Angle(90, 0, 0),
	},
	['models/props_phx/wheels/trucktire2.mdl'] = {
		price = 175000,
		name = L.discs_hint .. L.item_disc11,
		ang = Angle(90, 0, 0),
	},
	['models/hl2prewar/car002/car_002_wheel.mdl'] = {
		ang = Angle(0, 0, 0),
	},
	['models/hl2prewar/car005/car_005_wheel.mdl'] = {
		ang = Angle(0, -90, 0),
	},
	['models/hl2prewar/hatch/hatch_v2_wheel.mdl'] = {
		ang = Angle(0, 180, 0),
	},
	['models/hl2prewar/van/van_wheel.mdl'] = {
		ang = Angle(0, 0, 0),
	},
	['models/salza/trabant/trabant_wheel.mdl'] = {
		ang = Angle(0, 0, 0),
	},
	['models/salza/volga/volga_wheel.mdl'] = {
		ang = Angle(0, -90, 0),
	},
	['models/salza/zaz/zaz_wheel.mdl'] = {
		ang = Angle(0, -90, 0),
	},
	['models/props_vehicles/carparts_wheel01a.mdl'] = {
		ang = Angle(0, -90, 0),
	},
	['models/salza/moskvich/moskvich_wheel.mdl'] = {
		ang = Angle(0, 0, 0),
	},
}

function simfphys.GetWheelAngle(model)

	if not model then return end
	model = string.lower(model)

	local rim = simfphys.rims[model]
	if rim then return rim.ang end

	local v_list = list.Get("simfphys_vehicles")
	for listname, _ in pairs(v_list) do
		if v_list[listname].Members.CustomWheels then
			local FrontWheel = v_list[listname].Members.CustomWheelModel
			local RearWheel = v_list[listname].Members.CustomWheelModel_R

			if FrontWheel then
				FrontWheel = string.lower(FrontWheel)
			end

			if RearWheel then
				RearWheel = string.lower(RearWheel)
			end

			if model == FrontWheel or model == RearWheel then
				local Angleoffset = v_list[listname].Members.CustomWheelAngleOffset
				if Angleoffset then
					return Angleoffset
				end
			end
		end
	end

	local list = list.Get("simfphys_Wheels")[model]
	local output = list and list.Angle

	return output or Angle()

end
