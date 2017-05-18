//Xenomorph - Larva - Colonial Marines - Apophis775 - Last Edit: 11JUN16


/mob/living/carbon/Xenomorph/Larva
	name = "Bloody Larva"
	caste = "Bloody Larva"
	speak_emote = list("hisses")
	icon_state = "Bloody Larva"
	amount_grown = 0
	max_grown = 100
	maxHealth = 35
	health = 35
	plasma_gain = 1
	melee_damage_lower = 0
	melee_damage_upper = 0
	evolves_to = list("Drone", "Runner", "Sentinel") //Add sentinel etc here
	see_in_dark = 8
	caste_desc = "D'awwwww, so cute!"
	flags_pass = PASSTABLE | PASSMOB
	speed = -1.2 //Zoom!
	away_timer = 300
	tier = 0  //Larva's don't count towards Pop limits
	upgrade = -2
	crit_health = -25
	gib_chance = 25
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/Larva/proc/xenohide,
		/mob/living/carbon/Xenomorph/proc/vent_crawl
		)

/mob/living/carbon/Xenomorph/Larva/predalien
	icon_state = "Predalien Larva"
	caste = "Predalien Larva"
	evolves_to = list("Predalien")

/mob/living/carbon/Xenomorph/Larva/UnarmedAttack(atom/A)
	a_intent = "help" //Forces help intent for all interactions.
	. = ..()

/mob/living/carbon/Xenomorph/Larva/Stat()
	. = ..()
	if(.)
		stat(null, "Progress: [amount_grown]/[max_grown]")

//Larva Progression.. Most of this stuff is obsolete.
/mob/living/carbon/Xenomorph/Larva/update_progression()
	..()
	if(amount_grown < max_grown)
		amount_grown++
	if(!isnull(src.loc) && amount_grown < max_grown)
		if(locate(/obj/effect/alien/weeds) in loc)
			amount_grown++ //Double growth on weeds.
	return

//Larva code is just a mess, so let's get it over with
/mob/living/carbon/Xenomorph/Larva/update_icons()

	var/progress = "" //Naming convention, three different names
	var/state = "" //Icon convention, two different sprite sets

	switch(amount_grown)
		if(0 to 49) //We're still bloody
			progress = "Bloody "
			state = "Bloody "
		if(50 to 99)
			progress = ""
			state = ""
		if(100 to INFINITY)
			progress = "Mature "

	name = "\improper [progress]Larva ([nicknumber])"

	if(istype(src,/mob/living/carbon/Xenomorph/Larva/predalien)) state = "Predalien " //Sort of a hack.

	//Update linked data so they show up properly
	real_name = name
	if(mind)
		mind.name = name //This gives them the proper name in deadchat if they explode on death. It's always the small things

	if(stat == DEAD)
		icon_state = "[state]Larva Dead"
	else if(handcuffed || legcuffed)
		icon_state = "[state]Larva Cuff"
	else if(stunned)
		icon_state = "[state]Larva Stunned"
	else if(lying || resting)
		icon_state = "[state]Larva Sleeping"
	else
		icon_state = "[state]Larva"

/mob/living/carbon/Xenomorph/Larva/proc/xenohide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Alien"
	if(stat || paralysis || stunned || weakened || lying || is_mob_restrained() || buckled)
		src << "<span class='warning'>You cannot do this in your current state.</span>"
		return
	if(layer != TURF_LAYER + 0.2)
		layer = TURF_LAYER + 0.2
		src << "<span class='notice'>You are now hiding.</span>"
	else
		layer = MOB_LAYER
		src << "<span class='notice'>You have stopped hiding.</span>"
	return

/mob/living/carbon/Xenomorph/Larva/Bump(atom/AM as mob|obj|turf, yes)

	spawn(0)
		if(stat || !AM || !istype(AM) || AM == src || !yes)
			return

		if(ismob(AM))
			loc = AM.loc
			now_pushing = 0
			return

/mob/living/carbon/Xenomorph/Larva

	start_pulling(var/atom/movable/AM)
		return

	pull_response(mob/puller)
		return