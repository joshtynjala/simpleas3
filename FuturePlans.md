## Planned Features ##

The following features, extras, and supporting materials are either planned or being considered for future versions of SimpleAS3

  * The Flash authoring tool extension needs the ability to inject SimpleAS3 into any existing FLA file. Currently, the SimpleAS3 extension always creates a new FLA file.
  * More extensive examples should be created. They should demonstrate complete "real world" projects.
  * More quick-load functions like loadXML() or loadChild(). For example, JSON is a common API result format.
  * Create a plugin system for initializing and extending SimpleAS3. Include options for how invasive SimpleAS3 may be (does it modify prototypes? what scope should global functions use?).
  * Create utility classes written in strict AS3 that implement most of SimpleAS3's functionality. SimpleAS3 will use these internally. Use-case: Intermediate to advanced developers that want to work in strict mode, but may still want to use some of the shortcuts offered by SimpleAS3.
  * Provide centralized memory management for things that can't always be removed by unloadAndStop(). This could help ensure that SWFs always get garbage collected. Needs research to see if it's even possible.

## Questions to You ##

Please feel free to leave a comment below. Answer any or all of the following questions. These questions may change from time to time as new versions come out and new ideas are considered.

  * SimpleAS3 allows many things to be done the AS2 way (or very much like it). Is there anything else you wish could be simplified?
  * Is the documentation easy to understand? What could be improved? Could the organization of each page in the docs be better in any way?
  * Could a SimpleAS3 project be easier to create?
  * Do you intend to use multiple SWF files in a single project (i.e. load a SWF into another SWF)?
  * If SimpleAS3 were to include a set of downloadable examples, what sort of projects do you think would make good examples? (Examples: banner ads, blog widgets, "experience" marketing websites ...and what else?)