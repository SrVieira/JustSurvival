validVehicleModels={
    landstal = 400, bravura = 401, buffalo = 402, linerun = 403, peren = 404, sentinel = 405, dumper = 406, firetruk = 407, trash = 408, stretch = 409,
    manana = 410, infernus = 411, voodoo = 412, pony = 413, mule = 414, cheetah = 415, ambulan = 416, leviathn = 417, moonbeam = 418, esperant = 419,
    taxi = 420, washing = 421, bobcat = 422, mrwhoop = 423, bfinject = 424, hunter = 425, premier = 426, enforcer = 427, securica = 428, banshee = 429,
    predator = 430, bus = 431, rhino = 432, barracks = 433, hotknife = 434, artict1 = 435, previon = 436, coach = 437, cabbie = 438, stallion = 439,
    rumpo = 440, rcbandit = 441, romero = 442, packer = 443, monster = 444, admiral = 445, squalo = 446, seaspar = 447, pizzaboy = 448, tram = 449,
    artict2 = 450, turismo = 451, speeder = 452, reefer = 453, tropic = 454, flatbed = 455, yankee = 456, golfcart = 457, solair = 458, topfun = 459,
    seaplane = 460, bike = 461, faggio = 462, freeway = 463, rcbaron = 464, rcraider = 465, glendale = 466, oceanic = 467, dirtbike = 468, sparrow = 469,
    patriot = 470, quadbike = 471, coastgrd = 472, dinghy = 473, hermes = 474, sabre = 475, rustler = 476, zr350 = 477, walton = 478, regina = 479,
    comet = 480, bmx = 481, burrito = 482, camper = 483, marquis = 484, baggage = 485, dozer = 486, maverick = 487, coastmav = 488, rancher = 489,
    fbiranch = 490, virgo = 491, greenwoo = 492, cupboat = 493, hotring = 494, sandking = 495, blistac = 496, polmav = 497, boxville = 498, benson = 499,
    mesa = 500, rcgoblin = 501, hotrina = 502, hotrinb = 503, bloodra = 504, rnchlure = 505, supergt = 506, elegant = 507, journey = 508, chopperb = 509,
    mtb = 510, beagle = 511, cropdust = 512, stunt = 513, petrol = 514, rdtrain = 515, nebula = 516, majestic = 517, buccanee = 518, shamal = 519,
    hydra = 520, fcr900 = 521, nrg500 = 522, hpv1000 = 523, cement = 524, towtruck = 525, fortune = 526, cadrona = 527, fbitruck = 528, willard = 529,
    forklift = 530, tractor = 531, combine = 532, feltzer = 533, remingtn = 534, slamvan = 535, blade = 536, freight = 537, streak = 538, vortex = 539,
    vincent = 540, bullet = 541, clover = 542, sadler = 543, firela = 544, hustler = 545, intruder = 546, primo = 547, cargobob = 548, tampa = 549,
    sunrise = 550, merit = 551, utility = 552, nevada = 553, yosemite = 554, windsor = 555, mtruck_a = 556, mtruck_b = 557, uranus = 558, jester = 559,
    sultan = 560, stratum = 561, elegy = 562, raindanc = 563, rctiger = 564, flash = 565, tahoma = 566, savanna = 567, bandito = 568, freiflat = 569,
    cstreak = 570, kart = 571, mower = 572, dune = 573, sweeper = 574, broadway = 575, tornado = 576, at400 = 577, dft30 = 578, huntley = 579,
    stafford = 580, bf400 = 581, newsvan = 582, tug = 583, petrotr = 584, emperor = 585, wayfarer = 586, euros = 587, hotdog = 588, club = 589,
    freibox = 590, artict3 = 591, androm = 592, dodo = 593, rccam = 594, launch = 595, police_la = 596, police_sf = 597, police_vg = 598, polranger = 599,
    picador = 600, swatvan = 601, alpha = 602, phoenix = 603, glenshit = 604, sadlshit = 605, bagboxa = 606, bagboxb = 607, stairs = 608, boxburg = 609,
    farm_tr1 = 610, util_tr1 = 611
}

secret_key="b{mD967>YDWWx0ag"

function loadFile(path, count)
    if(not fileExists(path))then return end
    
    local file = fileOpen(path)
    if not file then
        return false
    end
    if not count then
        count = fileGetSize(file)
    end
    local data = fileRead(file, count)
    fileClose(file)
    return data
end

function saveFile(path, data)
    if not path then
        return false
    end
    if fileExists(path) then
        fileDelete(path)
    end
    local file = fileCreate(path)
    fileWrite(file, data)
    fileClose(file)
    return true
end

function addFileToMeta(path, meta)
    local xml = xmlLoadFile(meta)
    if(xml)then
        local exists=false
        for index,node in pairs ( xmlNodeGetChildren ( xml ) ) do
            if xmlNodeGetName ( node ) == "file" then
                if(xmlNodeGetAttribute(node,"src") == path)then
                    exists=true
                end
            end
        end

        if(not exists)then
            local child = xmlCreateChild(xml, "file")
            xmlNodeSetAttribute(child, "src", path)
            xmlSaveFile(xml)
            xmlUnloadFile(xml)
        end
    end
end