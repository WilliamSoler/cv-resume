// Ultimate ATS-Friendly + Polished Resume (Typst)
// Toggle "mode" to "ats" for a printer/ATS-safe variant without chips/colors.

#let cv = json("resume.json")
#let mode = "visual" // options: "visual" | "ats"

// Page + typography
#set page(
  paper: "a4",
  margin: (top: 1.5cm, right: 1.5cm, bottom: 1.5cm, left: 1.5cm),
)

#let fonts = (
  "Inter",
  "Source Sans 3",
  "Source Sans Pro",
  "IBM Plex Sans",
  "Helvetica Neue",
  "Helvetica",
  "Arial",
  "Noto Sans",
  "Liberation Sans",
)

#set text(font: fonts, size: 10.5pt, hyphenate: false, fill: rgb("#0f172a"))
#set par(justify: false, leading: 1.35em, spacing: 0.6em)

// Color palette
#let accent = rgb("#2563eb")
#let secondary = if mode == "ats" { rgb("#111827") } else { rgb("#1e40af") }
#let muted = rgb("#64748b")
#let light = rgb("#f1f5f9")
#let subtle = rgb("#e5e7eb")

// Global link style
#show link: set text(
  fill: if mode == "ats" { rgb("#0f172a") } else { accent },
  weight: 600,
)

// Spacing scale
#let space = (xs: 2pt, sm: 4pt, md: 6pt, lg: 10pt, xl: 14pt, xxl: 20pt)

// Horizontal rule for sections
#let hr() = {
  v(space.sm)
  line(length: 100%, stroke: 0.9pt + (if mode == "ats" { subtle } else { accent }))
  v(space.lg)
}

// Section block
#let section(title, body) = {
  v(space.xl)
  block(spacing: space.sm)[
    #set text(size: 11.5pt, weight: 800, fill: secondary, tracking: 0.03em)
    #upper(title)
    #hr()
    #body
  ]
}

// Modern "chip" for tags (disabled in ATS mode)
#let chip(t) = box(
  stroke: if mode == "ats" { none } else { 0.5pt + subtle },
  fill: if mode == "ats" { none } else { light },
  radius: 3pt,
  inset: (x: 8pt, y: 1.4pt),
  baseline: 0.82em,
)[
  #set text(size: 9pt, weight: 500)
  #t
]



// Bullets + separators
#let bullet = text(size: 12pt, fill: if mode == "ats" { rgb("#0f172a") } else { accent })[•]
#let contact-sep = text(size: 9pt, fill: muted)[ • ]

// --- HEADER ---
#align(center)[
  #block(spacing: space.sm)[
    #set text(size: 23.5pt, weight: 900, fill: secondary, tracking: 0.01em)
    #cv.basics.name
  ]

  #block(spacing: space.sm)[
    #set text(size: 12.5pt, weight: 700, fill: if mode == "ats" { rgb("#0f172a") } else { accent })
    #cv.basics.title
  ]

  #block(spacing: space.lg)[
    #set text(size: 10pt, fill: muted)
    #cv.basics.location
    #contact-sep #link("mailto:" + cv.basics.email)[#cv.basics.email]
    #contact-sep #cv.basics.phone
    #if cv.basics.linkedin != "" [
      #contact-sep #link(cv.basics.linkedin)[LinkedIn]
    ]
    #if cv.basics.github != "" [
      #contact-sep #link(cv.basics.github)[GitHub]
    ]
    #if cv.basics.website != "" [
      #contact-sep #link(cv.basics.website)[Portfolio]
    ]
    #if "english_level" in cv.basics [
      #contact-sep English: #cv.basics.english_level
    ]
  ]
]

#v(space.lg)

// --- PROFESSIONAL SUMMARY ---
#section("Professional Summary", [
  #set text(size: 10.5pt)
  #set par(leading: 1.4em)
  #cv.basics.summary
])

// --- CORE COMPETENCIES ---
#let chip_leading = 1.05em // 1.03–1.08em works well

#section("Core Competencies", [
  #set par(spacing: 0.45em)
  #for skill in cv.skills [
    #grid(
      columns: (auto, 1fr),
      gutter: 10pt,
      row-gutter: 4pt,
      // Left: label
      [
        #set par(leading: chip_leading)
        #set text(weight: 700, fill: secondary)
        #v(4pt) #skill.category:
      ],

      // Right: chips
      [
        #if mode == "ats" [
          #set par(leading: chip_leading)
          #set text(size: 10pt)
          #skill.items.join(" • ")
        ] else [
          #box(width: 100%)[
            #set par(leading: chip_leading)  // same leading
            #set text(size: 9pt)
            #let items = skill.items
            #for (i, item) in items.enumerate() [
              #chip(item)#if i < items.len() - 1 [#h(3pt)]
            ]
          ]
        ]
      ],
    )
  ]
])


// Helper for a job entry
#let job-entry(job) = block(spacing: space.md)[
  #grid(
    columns: (1fr, auto),
    gutter: 16pt,
    [
      #set text(size: 11pt, weight: 700, fill: secondary)
      #job.title
      #linebreak()
      #set text(size: 10.5pt, weight: 600, style: "italic")
      #job.company
    ],
    [
      #align(right)[
        #set text(size: 10pt, fill: muted, weight: 500)
        #if "location" in job [#job.location #linebreak()]
        #job.start — #job.end
      ]
    ],
  )

  #v(space.sm)

  #for bullet-text in job.bullets [
    #grid(
      columns: (auto, 1fr),
      gutter: 10pt,
      row-gutter: 4pt,
      [#v(2pt) #bullet],
      [
        #set text(size: 10pt)
        #set par(leading: 1.3em, hanging-indent: 0pt)
        #bullet-text
      ],
    )
  ]
]

// --- PROFESSIONAL EXPERIENCE ---
#section("Professional Experience", [
  #for (i, job) in cv.experience.enumerate() [
    #job-entry(job)
    #if i < cv.experience.len() - 1 [
      #v(space.lg)
    ]
  ]
])

// --- KEY PROJECTS ---
#if cv.projects.len() > 0 [
  #section("Key Projects", [
    #for project in cv.projects [
      #block(spacing: space.sm)[
        #set text(size: 11pt, weight: 700, fill: secondary)
        #project.name
        #linebreak()

        #set text(size: 10pt)
        #project.summary
        #linebreak()
        #v(space.md)

        #grid(
          columns: (auto, 1fr),
          gutter: 8pt,
          [
            #set text(size: 9.5pt, weight: 600, fill: muted)
            Technologies:
          ],
          [
            #if mode == "ats" [
              #set text(size: 9.5pt)
              #project.tech.join(" • ")
            ] else [
              // Fixed: properly handle the grid creation for project tech
              #let tech-chips = project.tech.map(t => chip(t))
              #let cols = calc.min(4, tech-chips.len())  // Max 4 columns
              #grid(
                columns: (auto,) * cols,
                gutter: 6pt,
                row-gutter: 6pt,
                ..tech-chips
              )
            ]
          ],
        )

        #if project.links.len() > 0 [
          #set text(size: 9.5pt, fill: if mode == "ats" { rgb("#0f172a") } else { accent }, weight: 600)
          Links: #project.links.map(l => link(l.url, l.label)).join(" | ")
        ]
      ]
      #v(space.md)
    ]
  ])
]

// --- EDUCATION & CERTIFICATIONS ---
#let show_education = cv.education.len() > 0
#let show_certs = cv.certifications.len() > 0

#if show_education or show_certs [
  #grid(
    columns: if show_education and show_certs { (1fr, 1fr) } else { (1fr,) }, // Fixed: added comma for single column
    gutter: 20pt,

    ..if show_education {
      (
        section("Education", [
          #for edu in cv.education [
            #set text(size: 10.5pt, weight: 600, fill: secondary)
            #edu.degree
            #linebreak()
            #set text(size: 10pt, weight: 400)
            #edu.institution
            #linebreak()
            #set text(size: 9.5pt, fill: muted)
            #edu.location • #edu.start — #edu.end
            #v(space.sm)
          ]
        ]),
      )
    } else { () },

    ..if show_certs {
      (
        section("Certifications", [
          #for cert in cv.certifications [
            #set text(size: 10.5pt, weight: 600, fill: secondary)
            #cert.name
            #if "year" in cert [
              #set text(size: 10pt, fill: muted)
              (#cert.year)
            ]
            #linebreak()
          ]
        ]),
      )
    } else { () }
  )
]

// --- LANGUAGES ---
#if cv.languages.len() > 0 [
  #section("Languages", [
    #for lang in cv.languages [
      #grid(
        columns: (auto, 1fr),
        gutter: 12pt,
        [
          #set text(size: 10pt, weight: 700, fill: secondary)
          #lang.name:
        ],
        [
          #set text(size: 10pt)
          #lang.level
        ],
      )
    ]
  ])
]

// --- ATS KEYWORDS (subtle, not hidden) ---
#if cv.keywords.len() > 0 [
  #v(space.xl)
  #block[
    #set text(size: 8.75pt, fill: muted.lighten(20%))
    #set par(leading: 1.1em)
    Technical Keywords: #cv.keywords.join(" • ")
  ]
]
