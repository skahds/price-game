basically like joker from balatro
these are called "strategies" ingame but in the code "card"

inherets from basicEnt, just won't be shown, and then have the UI do the work of being cool

define card properties

triggers:
ACTIVE -- deployable card which insta activate, can change stuff/spawn stuff on the grid etc
REACTIVE -- cards that react their own way? example:
trigger = {"ACTIVE"}
trigger = {"PRE", "POST"}