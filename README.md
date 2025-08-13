# PebblePath

## Table of Contents
- [Overview](#overview)  
- [Product Spec](#product-spec)  
- [Wireframes](#wireframes)  
- [Schema](#schema)  

---

## Overview

### Description
PebblePath is a mobile app that helps users practice multiple-choice questions, get instant feedback, and track completed questions as “tasks” for progress monitoring. The app loads questions from a JSON file--potentially connecting to company's item banking API--presents them one at a time, and after each attempt shows an explanation. Completed questions are automatically saved as tasks in persistent storage so users can review their learning history later.

---

### App Evaluation
- **Category:** Education / Productivity  
- **Mobile:** Designed for iOS, uses UIKit for interactive quiz UI and local persistence for saving progress.  
- **Story:** Helps learners reinforce knowledge through repeated practice and instant feedback, while tracking completion like a to-do list.  
- **Market:** Suitable for students, educators, and self-learners in any subject with MCQ practice.  
- **Habit:** Encourages daily use by letting users pick up where they left off and see progress.  
- **Scope:** MVP focuses on local quiz play and progress tracking; future updates could include cloud sync, leaderboards, and subject-specific question packs.

##Youtube video demo: 
- [https://youtube.com/shorts/XZjlaLRpKoQ?feature=share]
---

## Product Spec

### 1. User Stories

#### Required Must-have Stories
- [x] User can view a quiz question and four possible answers.  
- [x] User can select an answer and immediately see if it’s correct or incorrect.  
- [x] User sees an explanation for each question after answering.  
- [x] User progresses through the quiz question by question.  
- [x] User’s completed questions are saved as “tasks” in persistent storage (UserDefaults).  
- [x] User sees an alert when all questions are completed.  

#### Optional Nice-to-have Stories
- [ ] User can review saved tasks in a task list view.  
- [ ] User can delete or mark tasks incomplete.  
- [ ] User can choose a quiz topic or difficulty before starting.  
- [ ] User can view progress statistics (accuracy, streaks).  
- [ ] User can import custom question packs from JSON.  

---

### 2. Screen Archetypes
- **Practice Screen**  
  - Displays question text and four answer buttons.  
  - Handles answer selection, feedback alerts, and progress tracking.  

- **Task List Screen** *(optional/future)*  
  - Shows completed questions saved as tasks.  
  - Allows deletion or review of past questions.  

---

### 3. Navigation

#### Tab Navigation
- **Practice** – for answering quiz questions.  
- **Tasks** – for viewing completed question history (future).  

#### Flow Navigation
- **Practice Screen** → Feedback Alert → Next Question  
- **Practice Screen** → Quiz Finished Alert → End Session  
- **Tasks Screen** → Task Detail *(optional)*  

---

## Wireframes



## Schema

### Models

**Question**
| Property      | Type       | Description |
|---------------|-----------|-------------|
| question      | String    | The question text |
| options       | [String]  | Multiple-choice options |
| answerIndex   | Int       | Index of the correct answer |
| explanation   | String    | Explanation text shown after answering |
| isAnswered    | Bool      | Whether the question was answered |
| isCorrect     | Bool      | Whether the answer was correct |

**Task**
| Property      | Type       | Description |
|---------------|-----------|-------------|
| title         | String    | Saved question text |
| dueDate       | Date      | Date when the question was answered |
| isComplete    | Bool      | Always true for completed questions |

---

### Networking
*(Current version does not use a network; questions are loaded from `questions.json` in the app bundle. Future versions may use an API to fetch questions.)*

**Potential Future Endpoints:**
- **GET /questions** – Fetch quiz questions.  
- **POST /tasks** – Save completed question to server.  

