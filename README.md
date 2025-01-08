#  MatchedText

a SwiftuI View that highlights the parts of a String that are found within another String.

## Usage:

`MatchedText` works a lot like `Text`. Anywhere you want to present a `String` or `AttributedString`, you can use a `MatchedText`

    MatchedText("The quick brown fox jumped over the lazy dog.")

If you want a substring within the MatchedText to appear highlighted, then pass a `matchedTextFilter` in the environment:

    MatchedText("The word happy will appear highlighted.")
            .environment(\.matchedTextFilter, "happy")

Of course, you can pass `matchedTextFilter` down through the View hierarchy since it's an environment variable:

    List {
        ForEach(people) { person in
            MatchedText(person.name)
            MatchedText(person.streetAddress)
            MatchedText(person.city)
            MatchedText(person.state)
        }
    }
    .environment(\.matchedTextFilter, searchString)

## Styling the Matched Substrings:

By default, any substring within the `MatchedText` that matches the `matchedTextFilter` will appear in the accent color,
but you can style the highlight in any way that you would style an `AttributedString`:

    MatchedText("Matched text will appear underlined in pink") { string, range, font in
        string[range].underlineColor = .pink
    }
    .environment(\.matchedTextFilter, "pink")

## Limiting line length

If the string is very long, MatchedText may concatenate it in such a way that the highlighted section isn't shown.
If you pass `maxMatchedTextLength` down the environment, then `MatchedText` will concatenate its String 
in such a way that it presents the substring surrounding the `matchedTextFilter` limited in length to `maxMatchedTextLength`.

    MatchedText("A really long string that may not fit in a standard iOS phone screen. Still, this text will be shown if maxMatchedTextLength is in the environment. Other text will be concatenated so that it appears.")
        .lineLimit(1)
            .environment(\.matchedTextFilter, "this text")
            .environment(\.maxMatchedTextLength, 25)

        
## MultilineMatchedText

`MultilineMatchedText` presents a list of `MatchedText` Views, one for each line in its input string, that matches `matchedTextFilter`.
If a given line of text doesn't contain `matchedTextFilter`, then it's not shown.

Use `MultilineMatchedText` to give an executive summary of where a substring can be found in a longer `String`. 
Pass `maxMatchedTextLength` down the environment and you'll get a nice compact summary with lines concatenated to show the first match on each line.
