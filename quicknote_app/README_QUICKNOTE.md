# QuickNote App

A simple and intuitive notes application built with Slidev and Vue 3.

## Features

- ✅ **Create Note**: Add new text notes quickly with a prominent "Add Note" button
- ✅ **Edit Note**: Click on any note card to edit its title and content
- ✅ **Delete Note**: Remove notes with the delete button on each card
- ✅ **Search Notes**: Search through notes by keywords in title or content
- ✅ **Clean UI**: Minimal light theme with specified color palette
- ✅ **Local Storage**: Notes are automatically saved to browser localStorage
- ✅ **Responsive Design**: Works on desktop and mobile devices

## Color Scheme

- **Primary**: #ffffff (White background)
- **Secondary**: #f5f5f5 (Light gray for note cards)
- **Accent**: #4a90e2 (Blue for buttons and interactive elements)

## Usage

### Running the Application

```bash
# Install dependencies
npm install

# Start development server
npm run dev -- --port <available_port>

# Build for production
npm run build
```

### Features Overview

1. **Main Interface**:
   - Large "QuickNote" title with note emoji
   - Search bar at the top for filtering notes
   - Prominent "➕ Add Note" button
   - Grid layout displaying note cards

2. **Note Cards**:
   - Display note title, content snippet, and last updated date
   - Hover effects for better interactivity
   - Click to edit functionality
   - Delete button (🗑️) in the top-right corner

3. **Add/Edit Modal**:
   - Clean form with title and content fields
   - Save/Cancel buttons
   - Form validation (both fields required)
   - Automatically updates timestamps

4. **Search Functionality**:
   - Real-time filtering as you type
   - Searches both title and content
   - Clear "No results found" state

5. **Empty States**:
   - Welcoming message when no notes exist
   - Helpful "No results found" when search yields no results

## Technical Implementation

- **Framework**: Slidev (presentation framework)
- **Frontend**: Vue 3 with Composition API
- **Language**: JavaScript (ES6+) with TypeScript support
- **Styling**: Inline styles with custom CSS for responsive design
- **Data Persistence**: Browser localStorage
- **Build Tool**: Vite (included with Slidev)

## File Structure

```
quicknote_app/
├── components/
│   └── QuickNote.vue          # Main QuickNote component
├── slides.md                  # Main Slidev presentation file
├── package.json              # Dependencies and scripts
└── README_QUICKNOTE.md       # This documentation
```

## Component Architecture

The QuickNote component (`components/QuickNote.vue`) includes:

- **State Management**: Reactive refs for notes, search, and form state
- **CRUD Operations**: Create, read, update, delete functionality for notes
- **Search Logic**: Real-time filtering of notes
- **Local Storage**: Automatic persistence of notes
- **Event Handling**: User interactions and form submissions
- **Responsive Design**: Mobile-friendly layout

## Browser Support

- Modern browsers supporting ES6+ and Vue 3
- Local storage API required for note persistence

## Notes

- The application uses Slidev as the framework, making it suitable for presentation-style deployments
- All data is stored locally in the browser
- The app is fully self-contained with no external API dependencies
- Responsive design ensures usability across different screen sizes
