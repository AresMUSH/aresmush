# Txt Command

This is a very basic command designed to mimic real world texting. As of right now, it simply sends texts from one person to multiple people and shows as an emit. The command will store your "last texted", so you can do `txt =message` after you've texted someone the first time.

You can send texts to multiple people. All recipients must be online.

A more verbose txt command is planned, but this is "good enough for now".

## Installing

For now, you should ask skew for a link to DL the zip for this plugin. Then simply put it in `aresmush\plugins`.

Once it's in, make sure to use `load txt`.

## Configuring

### Text Monitoring

By default, this command "monitors" texts by sending them to a special channel, "TxtMon". This channel should exist, or else the code will throw an error. If you do not wish to monitor texts, please change `txt_send_cmd.rb` -- line 65 from "true" to "false". If you wish to change the channel, look for "TxtMon" on line 67 and replace it with the channel you wish to use.

Text monitoring is intended to be used for RP purposes. Specifically, so staff can keep track of hot topics *and* for some NPC big brother evil power something something to spy on unwitting characters.

Please make sure to indicate to players if text monitoring is being used (such as, adding this information to a help file.)

### Message format

The message format is contained in `local_en.yml`. There are two lines, in case you want to make sender and receiver see different things. By default, they are both set to: `%xh%xg<TXT>%xn (From %{sender}) -> %{recipients}%{message}`

This outputs as: `<TXT> From Skew -> (to Pikachu) Hello there!`

## Page Command

This plugin references the default AresMUSH page command. If that is not installed, this won't work! Specifically, it uses the DND and page lock features. If a person is set DND or page locked, you cannot txt them!