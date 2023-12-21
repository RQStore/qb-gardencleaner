Config = {}

Config.Lang = 'en'
Config.FixCarSpawnQB = false -- Set this to true if car is not spawning
Config.SpawnBack = false -- Spawns player next to the ped when gives back the car
Config.Seeds = true -- if you want hem to get randomly male or female seed 
--- Vehicle ---
Config.UsingFuel = false
Config.JobCar = 'speedo4'
Config.VehiclePoints = 15 -- the required level for vehicle
--- TARGET ---
Config.TargetName = 'qb-target'
Config.StartJobEmote = 'fa-solid fa-handshake-simple'
Config.ClothesJobEmote = 'fa-solid fa-shirt'

--- Items ---
Config.DrugItem = "weedplant_seedf" --Drug item 
Config.ShovelItem = "cleanershovel" --Shovel item
Config.Blower = "eblower" --Electric Blower Item
--- Levels ---
Config.Charvest = 10
Config.LeafBlower = 30
Config.CleanWindow = 50
--- JOB SETTINGS ---
Config.PaymentType = "cash" --Name of payment type like `Bank, Cash, Money and etc` [ONLY FOR QBCORE]
Config.Job = {
    StartJob = { -- Ped Location
        Coords = vector4(185.24281311035, -175.63838195801, 54.145919799805, 160.43276977539),
        Ped = 'a_f_m_bevhills_02',
        blip = {
            SetBlipSprite = 354,
            SetBlipDisplay = 4,
            SetBlipScale = 0.8,
            SetBlipColour = 5,
            SetBlipAsShortRange = true,
        }
    },
    CarControl = { --Spawn/Detete Car
        Coords = vector3(194.39616394043, -158.47570800781, 56.532531738281),
        heading = 247.32164001465,
        DrawDistance = 4.0
    }
}

Config.Clothes = {
    male = {
        components = {{["component_id"] = 0, ["texture"] = 0, ["drawable"] = 0},{["component_id"] = 1, ["texture"] = 0, ["drawable"] = 0},{["component_id"] = 3, ["texture"] = 0, ["drawable"] = 30},{["component_id"] = 4, ["texture"] = 0, ["drawable"] = 36},{["component_id"] = 5, ["texture"] = 0, ["drawable"] = 0},{["component_id"] = 6, ["texture"] = 1, ["drawable"] = 56},{["component_id"] = 7, ["texture"] = 0, ["drawable"] = 0},{["component_id"] = 8, ["texture"] = 1, ["drawable"] = 59},{["component_id"] = 9, ["texture"] = 0, ["drawable"] = 0},{["component_id"] = 10, ["texture"] = 0, ["drawable"] = 0},{["component_id"] = 11, ["texture"] = 0, ["drawable"] = 56},},
    },
    female = {
        components = {{["component_id"] = 0, ["texture"] = 0, ["drawable"] = 0},{["component_id"] = 1, ["texture"] = 0, ["drawable"] = 0},{["component_id"] = 3, ["texture"] = 0, ["drawable"] = 57},{["component_id"] = 4, ["texture"] = 0, ["drawable"] = 35},{["component_id"] = 5, ["texture"] = 0, ["drawable"] = 0},{["component_id"] = 6, ["texture"] = 1, ["drawable"] = 59},{["component_id"] = 7, ["texture"] = 0, ["drawable"] = 0},{["component_id"] = 8, ["texture"] = 1, ["drawable"] = 36},{["component_id"] = 9, ["texture"] = 0, ["drawable"] = 0},{["component_id"] = 10, ["texture"] = 0, ["drawable"] = 0},{["component_id"] = 11, ["texture"] = 1, ["drawable"] = 49},},
    }
}

Config.Peds = {
    [1] = "a_m_m_mexcntry_01",
    [2] = "a_m_m_indian_01",
    [3] = "a_m_m_salton_01",
    [4] = "a_m_m_socenlat_01",
    [5] = "a_m_m_stlat_02",
    [6] = "a_m_o_acult_02",
    [7] = "a_m_y_beachvesp_02",
    [8] = "a_m_y_busicas_01",
}

Config.JobWork = {
    [1] = {
        PayForOnePoint = math.random(50,250),
        XPForOnePoint = 0.5,
        ParkCarAt = vector4(-1600.25, -369.33966064453, 44.417068481445, 248.36743164063),
        Blip = {
            SetBlipSprite = 354,
            SetBlipDisplay = 4,
            SetBlipScale = 0.8,
            SetBlipColour = 5,
            SetBlipAsShortRange = true,
        },
        Dumpster = vec4(-825.10388183594, -25.017301559448, 39.085865020752, 118.06029510498),
        BinBags = {
            [1] = vector3(-1604.6487, -344.0188, 49.2116),
            [2] = vector3(-1605.6732, -345.4971, 49.2128),
        },
        Charvest = {
            [1] = vector3(-1606.8596, -371.7873, 46.4499),
            [2] = vector3(-1608.4360, -370.1949, 46.4269),
        },
        LeafBlower = {
            [1] = vector3(-1606.19, -342.46, 49.21),
            [2] = vector3(-1606.98, -333.51, 49.22),
        },
        CleanWindow = {
            [1] = vector4(-1609.9356689453, -356.37512207031, 49.347148895264, 321.33795166016),
        },
    },
    [2] = {
        PayForOnePoint = math.random(50,90),
        XPForOnePoint = 0.5,
        ParkCarAt = vector4(-946.27270507813, -683.99780273438, 25.573719024658, 17.322080612183),
        Blip = {
            SetBlipSprite = 354,
            SetBlipDisplay = 4,
            SetBlipScale = 0.8,
            SetBlipColour = 5,
            SetBlipAsShortRange = true,
        },
        Dumpster = vec4(-825.580078125, -25.016939163208, 39.112613677979, 289.07434082031),
        BinBags = {
            [1] = vector3(-948.16986083984, -710.07739257813, 19.919410705566),
            [2] = vector3(-947.89752197266, -720.33068847656, 19.919303894043),
            [3] = vector3(-952.63140869141, -720.34362792969, 19.919244766235),
            [4] = vector3(-949.11828613281, -720.34497070313, 19.919317245483),
            [5] = vector3(-932.23474121094, -738.56646728516, 19.927358627319),
            [6] = vector3(-904.54943847656, -743.13018798828, 19.925882339478),
        },
        Charvest = {
            [1] = vector3(-896.65185546875, -735.68157958984, 19.90697479248),
            [2] = vector3(-896.70391845703, -728.45867919922, 19.91156578064),
            [3] = vector3(-901.79638671875, -705.47113037109, 19.871412277222),
            [4] = vector3(-913.673828125, -705.83312988281, 20.096834182739),
            [5] = vector3(-924.57458496094, -700.89294433594, 20.735399246216),
            [6] = vector3(-942.15063476563, -701.92828369141, 20.439792633057),
        },
        LeafBlower = {
            [1] = vector3(-944.87109375, -719.06195068359, 19.921754837036),
            [2] = vector3(-952.03668212891, -734.28765869141, 19.922018051147),
        },
        
    },
    [3] = {
        PayForOnePoint = math.random(50,90),
        XPForOnePoint = 0.5,
        ParkCarAt = vector4(-822.02740478516, -32.28108215332, 38.485248565674, 345.14379882813),
        Dumpster = vec4(-825.580078125, -25.016939163208, 39.112613677979, 289.07434082031),
        Blip = {
            SetBlipSprite = 354,
            SetBlipDisplay = 4,
            SetBlipScale = 0.8,
            SetBlipColour = 5,
            SetBlipAsShortRange = true,
        },
        BinBags = {
            [1] = vector3(-841.95526123047, -27.589826583862, 39.901924133301),
            [2] = vector3(-841.07116699219, -22.534963607788, 39.901725769043),
            [3] = vector3(-842.35778808594, -19.813301086426, 39.901657104492),
            [4] = vector3(-855.37072753906, -12.169713973999, 40.564105987549),
            [5] = vector3(-855.294921875, -29.605152130127, 40.559711456299),
            [6] = vector3(-881.69598388672, -50.891426086426, 38.052318572998),
        },
        Charvest = {
            [1] = vector3(-878.57904052734, -42.424186706543, 38.390354156494),
            [2] = vector3(-882.03680419922, -38.150997161865, 38.56517791748),
            [3] = vector3(-886.6708984375, -32.181350708008, 38.440391540527),
            [4] = vector3(-882.23602294922, -31.534326553345, 38.793304443359),
            [5] = vector3(-877.88800048828, -33.027950286865, 39.108592987061),
            [6] = vector3(-869.91265869141, -35.459255218506, 39.605918884277),
        },
        LeafBlower = {
            [1] = vector3(-867.02447509766, -41.524517059326, 39.359313964844),
            [2] = vector3(-870.4130859375, -42.164318084717, 39.052577972412),
        },
        CleanWindow = {
            [1] = vector4(-842.23522949219, -25.023313522339, 40.398384094238, 92.186012268066),
            [2] = vector4(-841.98022460938, -30.787269592285, 39.392261505127, 91.267127990723),
            [3] = vector4(-856.39849853516, -47.275268554688, 39.160945892334, 26.569995880127),
            [4] = vector4(-862.36206054688, -33.242321014404, 40.559482574463, 254.34422302246),
        },
    },
    [4] = {
        PayForOnePoint = math.random(50,90),
        XPForOnePoint = 0.5,
        ParkCarAt = vector4(-882.0087890625, 20.875774383545, 45.429012298584, 138.05030822754),
        Dumpster = vec4(-825.580078125, -25.016939163208, 39.112613677979, 289.07434082031),
        Blip = {
            SetBlipSprite = 354,
            SetBlipDisplay = 4,
            SetBlipScale = 0.8,
            SetBlipColour = 5,
            SetBlipAsShortRange = true,
        },
        BinBags = {
            [1] = vector3(-887.09893798828, 43.433700561523, 49.146984100342),
            [2] = vector3(-881.75665283203, 38.664920806885, 49.064281463623),
            [3] = vector3(-882.35760498047, 36.782703399658, 49.033142089844),
            [4] = vector3(-880.82196044922, 35.939075469971, 49.10001373291),
            [5] = vector3(-879.53826904297, 36.601951599121, 49.103397369385),
            [6] = vector3(-879.18273925781, 37.720363616943, 49.082733154297),
        },
        Charvest = {
            [1] = vector3(-868.06341552734, 44.223152160645, 48.781414031982),
            [2] = vector3(-866.76641845703, 40.10502243042, 48.737377166748),
            [3] = vector3(-907.38635253906, 53.998569488525, 49.643909454346),
            [4] = vector3(-916.87750244141, 48.650882720947, 49.680381774902),
            [5] = vector3(-923.87353515625, 56.975925445557, 49.876617431641),
            [6] = vector3(-927.51977539063, 62.602645874023, 50.678443908691),
        },
        LeafBlower = {
            [1] = vector3(-926.80828857422, 70.855224609375, 52.580631256104),
            [2] = vector3(-918.52795410156, 68.021301269531, 52.776775360107),
            [3] = vector3(-906.43890380859, 61.835048675537, 49.639373779297),
        },
    },
}

--- FUNCTIONS ---



QBCore = exports['qb-core']:GetCoreObject()
function SetCarFuel(callback_vehicle)
    if Config.UsingFuel then
        exports['LegacyFuel']:SetFuel(callback_vehicle, '100')
    end
end
function Notify(message)
    QBCore.Functions.Notify(message, "primary")
end
