---
layout: post
title: Sins and wins of the code review
modified: 2021-01-24
tags: [git, code-review, self-development]
---

## A witness of the reality

Are you a developer and working genuinely hard with your team on some awesome project which should change the world? I know this feeling, it’s great, you feel thrilled. Moreover, it reassures you that this project of yours is something you want to engage with! Although after a while, when the excitement frenzy is getting away, then comes an everyday routine. This is the time, when code review’s angels and demons reveal themselves, especially when everyone is busy with their own, important tasks that have to be done.

> Disclaimer: I might use Pull Request (PR for short) or Merge Request (MR for short) equivalently while writing. The difference is mainly that the PRs come from Github users, and MRs is the term used in Gitlab.

Let's start with some formal definition to remember what a code review is, so we could grasp a good starting point and focus on iterating the possible pitfalls.

> Code review (sometimes referred to as peer review) is a software quality assurance activity in which one or several people check a program mainly by viewing and reading parts of its source code, and they do so after implementation or as an interruption of implementation. At least one of the persons must not be the code's author. The persons performing the checking, excluding the author, are called "reviewers". - Wikipedia

Honestly, I am not a perfect reviewer. I wish, I would be a one, but even now after 7 solid years in the industry, sometimes I still just forgot how important is to say few nice words about someone's great work accomplished in a PR. I always strive to give the best possible feedback to the author to improve a feature/product in order to, or additionally just simply to give someone a tip because I believe (s)he would benefit from it. I am doing this because I honestly appreciate it if someone's giving me detailed feedback, so at the end of the day, I can improve myself and be a better companion for my team. However, this process of writing and reviewing sometimes can be obscured by internal or external factors. In this article, I will try to tackle down those factors and severe you in a couple of essential mistakes with a tip on how to improve or solve them.

## The author and the reviewer

You need to be aware, that you can take a look at the code reviewing process from 2 perspectives (or even more but it's out of our scope):

- from the author's perspective, where the developer writes the code and it will be analyzed later by the reviewer.
- from the reader's perspective, where the reviewer leaves feedback regarding the author's code and searching what is happening with the code or even sometimes forecasting what could have happened while executing code in the future to follow best code practices.

Those two perspectives look similar, but they carry a completely different charge. Sometimes this charge is connected with external factors which are everything around a single person (e.g.: finding the best approach for the project, following best practices, respecting company hierarchy) or internal factors which mainly focus on a single person itself (e.g.: an emotional connection with work, character, hold resentment/sympathy for a person).

## Sins and their wins

In the first few sentences, I want to emphasize that code reviews should always hold a positive change. It's important to remember **the code review process aims to improve**, not to destroy nor question someone's work. When we take a positive attitude while the code review, all the work we do as professionals and also as persons, would be much better - like a win-win scenario. Shall we begin?

**Leaving only negative comments.** I've chosen this as a first reviewing sin due to its highest impact on the whole code review process. Why? We are humans, people with emotions - let put ourselves in a situation when all do is "incorrect" or "wrong" - it's not a good feeling, right? Generally, developers sometimes tend to get too emotional about the things they create. This connection is sometimes so strong, that an innocent comment, which might sound negative while reading could be just a trigger to multiple scenarios of having a bad mood, frustration, start disliking someone, or even unnecessary tensions between people in the project - generally speaking, nothing good. It would be an extremely rare situation if someone would think about negative comments through the prism of a good and constructive critique because, in the end, it would make him a better developer/person.

Win: "Light it the tunnel" approach. Among the comments, leave in someone's PR also a few good words what did you like, e.g:

> "Woah man, I wish I would more often write a code so clean as yours. It was a pleasure to read it. Nice work!"

It's not about to suck up to somebody (no, far from it), rather show you appreciate someone's work, even despite a fact that a couple of things need to be improved - you see a solid work which the author put in it.

**Taking code reviews too personal.** As I already mentioned above, each person may take the work they do differently. Someone will have a higher threshold regarding receiving the critique, but another with a much more fragile character would feel like under a cannon shot. This should never be like that, and this case is mostly connected with higher self-awareness and work on self-development.

Win: It's important to take code reviews in an impersonal way. This is for all sides, the authors and the reviewers. In other words, this means, to take the job without so many emotions. Also to not favor or disrespect someone, if we like somebody or not (due to unknown reason) and should not obscure the real feedback you should write as the reviewer.

**Do not forget to describe what you are referring to and provide a good reason why you wish to change it.** While doing a review, some people tend to be too minimalistic and condense their thoughts in too few words, like:

- "Remove this function"
- "Why you change this feature?"

Win: Either you write a comment regarding a specific line in code, or starting a more general thought, always justify, **why this change is important to be updated**. You need to remember that, someone who will read your comment can't "read minds" and usually need 2 things to understand: **what** and **why**.

If at least one point is missing, the review doesn't make much sense because from at least one side it will be incomplete, and to solve the discussion, it will require guessing to understand and/or additional ping-pong discussion which usually leads to losing time. Think, how faster and more effective you could be, just if you would never, ever forget about providing "what" and give a reason "why" 🙂?

**A written text is much poorer in information than a speech.** If someone talks to you, except a piece of pure information, you perceive much more, like:

- **an intonation** of a person who said it,
- **a mood** of the person who said it,
- you could even feel **an intention** which comes with said words,

In other words, speech is richer with information than a purely written text. If you would compare speech to static text, many people may misinterpret the words you wrote. A good example would be the school language lessons, where we all have to analyze/guess "what the author intended to say" except the words he wrote.

Win: When writing a text/comment for a programmer, IMO it's good to use emojis 🙂. The emojis add this additional emotional charge to the bare text, so the other side may better perceive and understand the information. I understand, that some companies may not be allowed emojis, or some people may think about emojis as a habit of immature people, but it's not about judging who is the author of the text, it's about what kind of information this text (with emojis) could pass on to you so could you get best of it - and this should matter 🙂.

**A review without executing/running the code.** I am calling it a "dry-review", so as not to get your hands wet (dirty) 😉. This problem is about reviewing the code without even checking if the code which was changed is running correctly (a part of executing automated testing in the pipeline) in the product.

Win: This is a tricky one because "it depends" on what your team agreed on. But for now, let's say if someone is expecting from you, that you will make a review of his code - just do it, it might take a bit more time but if your team follows these practices then honor them and in the next retrospective meeting say that you would like to automate some repetitive tasks from the review process.

Apart from reading the code, it's best practice to execute it and check if:

- new changes are running and not breaking the application

  > e2e test could help to "auto-detect" some cases, but it cost time of maintaining them.

- new changes fit the concept of the whole application (this would also be a part of UX/UI design review)
- new changes are not breaking new and existing features logical (and functional/graphical - which also would be partly in UX/UI design review)

**Checking the only added or removed code.** This is somehow connected with the previous point _"fit to the concept of the whole application"_. In here, additionally to the previous point, I want to emphasize how the added or removed code can impact the application and already running features (production code), if it would not be checked. In the best case, it would not do any harm, but in the worst case, it could cost the team much more at a later time with refactoring the existing codebase or even your client losing their clients. Like a poison, these problems are nasty and I consider them as the most difficult to learn for Jung developers.

Win: The reviewer should consider (and in this case "assume" would be a good thing) that the code which is under the revision "is a not working code", so only then a solid review could prove you wrong. Although, of course, I've got to draw the line somewhere, how deep you should go. The simplest answer would be: "do not go into a rabbit hole" or in other words, do not sink for hours in deep review, the other project's automation tools should do it for you - focus on the surface.

**Too frequently pointing out code syntax.** This point for some purists might be a huge problem therefore they are strict as hell while reviewing a code and pointing all, even the smallest syntax problems. This is not the perfect solution to the problem. I can only imagine that those purists strive to have a perfect, clean code. However, in my career, it's almost impossible to achieve, especially when working with 10+ developers on the same codebase. There will always be "something".

Win: reading code is highly important, this unquestionable point. Programmers spend most of the time reading the code than writing it, so it supposes to be good readable, or simply clean. But in this cleanliness must also have some limitations. Each person may find reading code better in another way. If you noticing that someone is leaving a code "dirty" or the style of a code don't match with the rest - this is a good point to discuss if everyone is using the same code formatters and more important if everyone is aware of the same way of styling the code in the team. Leave a comment only when it's important, but when it's too easy to criticize, please stop for a moment and discuss how each of you do/would/should write the code. Additionally raise this topic in the team (e.g: during stand-up or retro) and document somewhere what are your code standards.

> My rule is simple while writing the code, I always try to keep the style of my code to the code I find in the file. Additionally, I'll always try to follow [The Boy Scout Rule](https://97-things-every-x-should-know.gitbooks.io/97-things-every-programmer-should-know/content/en/thing_08/) and leave the code "cleaner" as I found before. Only then I do have a feeling that the code I wrote is good and I would give the reader (and me in the future, as well) the best possible experience and starting point for implementing a new feature. Any exceptions I am reporting to my team in the meetings.

**Leaving checking tests out of reviewing scope.** A lot of developers forgetting to check if the tests are matching to newly applied changes. Usually, the thinking is:

> "Oh, the tests are passing, so the code works well. Next!"

Oh, how far it could be from true. Nevertheless, I will cover testing of code in another article as this topic is for me genuinely interesting, mostly because when you would ask each developer in the team, possibly they might have a different understanding of "what the tests are", "what they suppose to test" or "how to work with them when I don't have much time".

Win: A winning scenario is simple, check if the code has been tested and if so, then check if the test cases are matching with newly implemented updates to the code. Do not go too deep,

**Heavy PRs.** When you have a PR, which has more than 500 lines of changes, you might toil at reviewing the code you got, and a nice, pleasant review could become a nightmare. PRs tend only to grow, so putting so many things to do in a single ticket/issue, can be a terrible choice - terrible for a developer, but intuitive or obvious for other parties (PO, managers).

Win: It's important to know what needs to be implemented and then divide this into a smaller task that can be implemented and easily understand by developers. Developers do usually from 1 to 10 issues per day (depends on the size) and tend to jump between those problems frequently. They load in their mind tons of information and they need to process them, therefore it's so crucial to make issues relatively small. My golden ratio is to fit with the issue in 1 day. Of course, sometimes it's not possible, then I always start wondering if it would be possible or/and wise to divide it into smaller chunks - if not at least sort them thematically. For bigger issues that are difficult to divide, I find it the most practical, to divide the implementation of views from the application logic and connection with the backend. In the end, it gives a different variation of difficulty for issues, so everyone in the team can find some task which suits his best.

**Confusing and supply disinformation commits.** Ah, commits. How poor the world would be without them? They can be the greatest advantage or dead weight. "Show me your commits and I will tell you how good you are" - in other words, about using a version control system the man could write a book. The subjugation of the version control system is one thing, but using it to the advantage of documenting the project is another thing.

Win:
- keep commits small,
- many commits are good unless they are small,
- comply with your team's commits naming convention,
    - write what has been done in the commit
    - some find using present-tense, imperative-style commit messages as good practice (e.g: "Add login screen and connect to signup page") because while restructuring commits will tell you what the commit will bring to you after applying it ([reference](https://stackoverflow.com/q/3580013/1977012)).
- do not pack everything in a single commit, rather separate what you do into logical small commits so they are good to understand while reading and later squashing them.
- before sending to review, group-related commits into a single entity, it will bring the cleaner history of commits to the reviewer.

**Fixing too much in a single PR.** The Boy Scout Rule, when used too literally may bring you to the place when except for what you need to deliver in the issue, you also fixing few other bugs. This is usually practiced by undisciplined developers, but should not happen. The reason is simple, fixing one bug may bring others, therefore:

Win: Fix only things which your team agreed on in the issue, nothing more. You can report things to improve in comments sections, where they could be evaluated by your team and finally become real bugs reported in the system. Some managers also may bring to the top a financial aspect of doing too many in a single issue because the client may not wish this fix or even pay for it.

**Not doing a self-review before requesting a review.** Self-reflection on what you did is often underestimated but IMO is a crucial part of a developer career and self-improvement in general. The better you can reflect on your code the better developer and team player you would be.

Win: after writing the code, sent it to PR, and do a self-review in the tool your team is using (GitHub, Gitlab, JIRA, or other). Seeing your code as the reviewer would see it, would give you an opportunity to yourself in the position of the reviewer (reviewing your own code) and potentially find obvious bugs which a reviewer would detect. This step is not about finding all possible pitfalls in your own code, but mostly the obvious ones. It's also an important step in reflection on your code and what you still need to improve. Additionally, the fewer things the reviewer would need to write in your PR, the more they will love to review your PRs again - as they will assume you are good and deliver quality stuff.

**Requesting a review of a dirty code.** After you have complete your solution (it's finally workable) do not send it directly to the review. Clean your solution first and then send it to the review. Reviewing a dirty code is basically useless because even when the solution is working the code may look incorrect and not be accepted by team code standards.

Win: Remove added comments, run code formatter against updated files and never send a dirty code to review unless you want to be considered a newbie or dumb. The other people spent their time and skills reviewing your stuff, so appreciate it and learn from them. If you will value others, then others will value you and your work.

**Lack of good information flow.** Communication in web development is essential and equally important to the skills you will bring to the team. Even when you are a god of coding but suck in communication, you might become an outcast and feel bad in the team and vice versa. Great communication can speed up any project progress for days or weeks and additionally build good vibes in the team. I see it as:

Win: When you finish your PR, mark it in your source code management tool (GitHub, Gitlab, JIRA, ...) and inform your team about it in some communication channel. This may speed up work due to some of your colleagues may wait for it (or/and need it as a base for something else). Collaborate and work together.

<div class="mermaid">
graph LR
  A[good team communication] --> B[good team mood]
  B[good team mood] --> C[productive work] 
  C[productive work] --> D[excellent results]
  D-->A
</div>

### Final notes

Do I reach the bottom of this topic? Definitely not. I wish, I could write here more, but then this would be a book instead of an article 🙂.

Remember, **all things about the code review is to discover and learn**. Discover possible ways to improve the project and learn to make things better in the future. Do better and be better.

Good feedback always should strive to be positive with enough space for reasonable but gentle critique.

I would love to know your opinion about it. Let me know what are your top sins and wins of code review. The comment section is yours.
