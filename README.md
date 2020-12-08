# Automatic Labelling for IPE

[IPE](http://ipe.otfried.org/) is an extensible drawing editor software specially targeted at making figures for inclusion into LaTeX documents, as well as multi-page PDF presentations.

This repository contains a small extension of IPE, a so-called _ipelet_. The ipelet in this repository automatizes the repetitive task of manual edition of objects' labels. It offers single, free insertion of labels, and also multiple, constrained insertion of labels attached to several objects.

- Single, free insertion of labels: add labels one by one while being able to choose their position in the page freely.

![Inserting labels one by one.](figures/progress_single.gif)

- Multiple, constrained insertion: select several objects in your document and add the labels next to them in an orderly fashion.

![Inserting multiples labels at one. The dots are selected prior to label insertion.](figures/progress_multiple.gif)

## How to use it

Adding labels is fairly simple. First, one has to set the string with which the label is going to be generated. From now on, this string will be referred to as the _labelling expression_. This string has a syntax flexible enough to allow arithmetic expressions of many kinds, and at its core we find a counter. This counter increases one step for every label inserted (the exact value of this step is customizable by the user!) and is used to generate the labels in a very predictable way.

First, access the appropriate menu to set the labelling expression:

![Selecting the appropriate menu: `Ipelets` > `Automatic labelling` > `Set labelling expression`.](figures/select_menu.png)

Then, in the menu, write the desired labelling expression:

![Setting the labelling expression.](figures/enter_labelling_expression.png)

Now follow a few examples of what a labelling expression can be:

- The labelling expression `$x_{%% ^L %%}$` produces an `x` with a subscript that contains the value of the counter, all surrounded by `$`. Since (by default) the counter starts at 1, the subscripts generated are the natural numbers: $x_1$, $x_2$, $x_3$, ...,

- `%% ^L*^L %%` produces the squares of the natural numbers,

- `%% ^L^2 %%` also produces the squares of the natural numbers,

- `%%^L%%/100` produces the typical "x out of 100": `x/100`,

- and, similarly, in the expression `This is object number %%^L%%. Its associated variable is $x_{%%^L%%}$` the `%%^L%%` are replaced by the value of the counter.

This means that the `^L` inside the `%%`-delimited string is replaced by a numerical value which is incremented after a label is added. So `^L` is the counter, and the increment is the `step`!

### The format of the labelling expression

More generally, any labelling expression can contain several chunks of `%%`-delimited strings (inbetween arbitrarily long senteces) within which is only allowed an arithmetic expressions which can, optionally, use the counter `^L`. A labelling expression is legal when it has `%%`-strings correctly delimited (as a rule of the thumb, it must have an even number of `%%`), and the contents within `%%`-strings comply with LUA's format of arithmetic expressions -- accounting for the `^L`, that is. This means that besides the usual arithmetic expressions using `+`,`-`,`*`,`/` and `^` one can also include trigonometric functions (e.g., `sin`, `cos`, ...), logarithms (`log`), square root (`sqrt`), and so on, all using the reference to the counter `^L`.

### Using the ipelet in a comfortable way

Users are strongly encouraged to add custom shortcuts to IPE so that this ipelet can be used comfortably. One of the possibilities is
    
	-- assign a shortcut to inserting labels
	ipelet_1_automatic_labelling = "Ctrl+D",

	-- assign a shortcut to modifying the labelling expression
	ipelet_2_automatic_labelling = "Ctrl+Alt+D",

## Short user manual

### Inserting a label

Click on `Ipelets` > `Automatic labelling` > `Insert label` (or use the shortcut) in order to generate a new label. Users willing to label several objects in one click must be aware that objects are labelled in the same order they were introduced into IPE. Objects must be selected prior to making the labels.

![Labelling dots that were inserted into IPE in zig-zag.](figures/order_1.gif)
![Labelling dots that were inserted into IPE in counter-clockwise order.](figures/order_2.gif)

### Set a custom labelling expression

Click on `Ipelets` > `Automatic labelling` > `Set labelling expression` (or use the shortcut) in order to introduce a custom labelling expression into IPE.

### Set custom step increment

Click on `Ipelets` > `Automatic labelling` > `Set step increment` in order to change the step increment. This step can be any real number.

### Reset the label counter

In order to set the label counter back to 0, simply click on `Ipelets` > `Automatic labelling` > `Reset label counter`.

### Set counter to a custom value

If the user wishes to set the counter's value to some value other than 0, simply click on `Ipelets` > `Automatic labelling` > `Set counter value`.

### Set label geometry

Labels associated to objects are usually placed near the corresponding object, by an offset of `x=5` and `y=0` by default. This can be changed by clicking on `Ipelets` > `Automatic labelling` > `Set label geometry`. 

## Installation

Copy the file [automatic_labelling.lua](https://github.com/lluisalemanypuig/autolabipe/blob/master/automatic_labelling.lua) to your `~/.ipe/ipelets` or other directory for ipelets.

## History of changes

### 5th August 2020

Added GIFs (made with [gifcurry](https://github.com/lettier/gifcurry)).

### 5th June 2020

- Allow users to set a custom counter value.
- Fixed bugs. When checking that the input in setting a custom counter step and a custom counter value, the warning message to be displayed tried to concatenate a string with a `nil` value.

### 3rd June 2020

Added custom step increment for the label counter.

### 31st May 2020

Created repository
