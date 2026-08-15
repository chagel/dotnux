# fcitx5 classic UI theme, generated from the current Omarchy palette.
#
# Rendered by omarchy-theme-set-templates into
#   ~/.local/state/omarchy/current/theme/fcitx5.conf
# which ~/.local/share/fcitx5/themes/omarchy/theme.conf symlinks to, so the
# candidate popup follows whatever theme is active.
#
# fcitx5 caches the parsed theme, so a re-render alone changes nothing on
# screen -- the theme-set hook in hooks/theme-set.d/ reloads it.

[Metadata]
Name=Omarchy
Version=1
Author=Omarchy
Description=Generated from the active Omarchy theme
ScaleWithDPI=True

[InputPanel]
# Candidate text, and the selected candidate drawn on the accent bar below.
NormalColor={{ foreground }}
HighlightCandidateColor={{ background }}
HighlightColor={{ background }}
HighlightBackgroundColor={{ accent }}
PageButtonAlignment=Last Candidate

[InputPanel/TextMargin]
Left=8
Right=8
Top=6
Bottom=6

[InputPanel/ContentMargin]
Left=4
Right=4
Top=4
Bottom=4

[InputPanel/Background]
Color={{ background }}
BorderColor={{ accent }}
BorderWidth=1

[InputPanel/Background/Margin]
Left=2
Right=2
Top=2
Bottom=2

[InputPanel/Highlight]
Color={{ accent }}

[InputPanel/Highlight/Margin]
Left=6
Right=6
Top=4
Bottom=4

[Menu]
NormalColor={{ foreground }}
HighlightCandidateColor={{ background }}

[Menu/Background]
Color={{ background }}
BorderColor={{ accent }}
BorderWidth=1

[Menu/Background/Margin]
Left=2
Right=2
Top=2
Bottom=2

[Menu/ContentMargin]
Left=4
Right=4
Top=4
Bottom=4

[Menu/Highlight]
Color={{ accent }}

[Menu/Highlight/Margin]
Left=6
Right=6
Top=4
Bottom=4

[Menu/Separator]
Color={{ muted }}

[Menu/TextMargin]
Left=8
Right=8
Top=6
Bottom=6
