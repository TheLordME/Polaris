/datum/artifact_effect/teleport
	name = "teleport"
	effect_type = EFFECT_BLUESPACE
	effect_state = "pulsing"
	effect_color = "#88ffdb"

/datum/artifact_effect/teleport/DoEffectTouch(var/mob/user)
	var/atom/holder = get_master_holder()
	var/weakness = GetAnomalySusceptibility(user)
	if(prob(100 * weakness))
		to_chat(user, "<font color='red'>You are suddenly zapped away elsewhere!</font>")
		if (user.buckled)
			user.buckled.unbuckle_mob()

		var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread()
		sparks.set_up(3, 0, get_turf(user))
		sparks.start()

		user.Move(pick(trange(50, get_turf(holder))))

		sparks = new /datum/effect_system/spark_spread()
		sparks.set_up(3, 0, user.loc)
		sparks.start()

/datum/artifact_effect/teleport/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(M)
			if(prob(100 * weakness))
				to_chat(M, "<font color='red'>You are displaced by a strange force!</font>")
				if(M.buckled)
					M.buckled.unbuckle_mob()

				var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread()
				sparks.set_up(3, 0, get_turf(M))
				sparks.start()

				M.Move(pick(trange(50, T)))
				sparks = new /datum/effect_system/spark_spread()
				sparks.set_up(3, 0, M.loc)
				sparks.start()

/datum/artifact_effect/teleport/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange, T))
			var/weakness = GetAnomalySusceptibility(M)
			if(prob(100 * weakness))
				to_chat(M, "<font color='red'>You are displaced by a strange force!</font>")
				if(M.buckled)
					M.buckled.unbuckle_mob()

				var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread()
				sparks.set_up(3, 0, get_turf(M))
				sparks.start()

				M.Move(pick(trange(50, T)))
				sparks = new /datum/effect_system/spark_spread()
				sparks.set_up(3, 0, M.loc)
				sparks.start()
