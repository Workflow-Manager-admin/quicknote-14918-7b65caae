<script setup lang="ts">
import { ref, computed, onMounted } from "vue";

// Define note interface
interface Note {
  id: string;
  title: string;
  content: string;
  createdAt: Date;
  updatedAt: Date;
}

// Reactive state
const notes = ref<Note[]>([]);
const searchQuery = ref("");
const showAddForm = ref(false);
const editingNote = ref<Note | null>(null);
const newNoteTitle = ref("");
const newNoteContent = ref("");

// PUBLIC_INTERFACE
// Computed property to filter notes based on search query
const filteredNotes = computed(() => {
  if (!searchQuery.value) return notes.value;

  const query = searchQuery.value.toLowerCase();
  return notes.value.filter(
    (note) =>
      note.title.toLowerCase().includes(query) ||
      note.content.toLowerCase().includes(query)
  );
});

// PUBLIC_INTERFACE
// Load notes from localStorage on component mount
onMounted(() => {
  loadNotes();
});

// PUBLIC_INTERFACE
// Load notes from localStorage
function loadNotes() {
  const savedNotes = localStorage.getItem("quicknotes");
  if (savedNotes) {
    notes.value = JSON.parse(savedNotes).map((note: Note) => ({
      ...note,
      createdAt: new Date(note.createdAt),
      updatedAt: new Date(note.updatedAt),
    }));
  }
}

// PUBLIC_INTERFACE
// Save notes to localStorage
function saveNotes() {
  localStorage.setItem("quicknotes", JSON.stringify(notes.value));
}

// PUBLIC_INTERFACE
// Generate unique ID for notes
function generateId(): string {
  return Date.now().toString(36) + Math.random().toString(36).substr(2, 9);
}

// PUBLIC_INTERFACE
// Show add note form
function showAddNoteForm() {
  resetForm();
  showAddForm.value = true;
}

// PUBLIC_INTERFACE
// Hide add/edit form
function hideForm() {
  showAddForm.value = false;
  editingNote.value = null;
  resetForm();
}

// PUBLIC_INTERFACE
// Reset form fields
function resetForm() {
  newNoteTitle.value = "";
  newNoteContent.value = "";
}

// PUBLIC_INTERFACE
// Save note (create or update)
function saveNote() {
  if (!newNoteTitle.value.trim() || !newNoteContent.value.trim()) return;

  if (editingNote.value) {
    // Update existing note
    const index = notes.value.findIndex((n) => n.id === editingNote.value?.id);
    if (index !== -1) {
      notes.value[index] = {
        ...notes.value[index],
        title: newNoteTitle.value.trim(),
        content: newNoteContent.value.trim(),
        updatedAt: new Date(),
      };
    }
  } else {
    // Create new note
    const newNote: Note = {
      id: generateId(),
      title: newNoteTitle.value.trim(),
      content: newNoteContent.value.trim(),
      createdAt: new Date(),
      updatedAt: new Date(),
    };
    notes.value.unshift(newNote);
  }

  saveNotes();
  hideForm();
}

// PUBLIC_INTERFACE
// Edit existing note
function editNote(note: Note) {
  editingNote.value = note;
  newNoteTitle.value = note.title;
  newNoteContent.value = note.content;
  showAddForm.value = true;
}

// PUBLIC_INTERFACE
// Delete note
function deleteNote(id: string) {
  if (confirm("Are you sure you want to delete this note?")) {
    notes.value = notes.value.filter((note) => note.id !== id);
    saveNotes();
  }
}

// PUBLIC_INTERFACE
// Get content snippet for display
function getContentSnippet(content: string, maxLength = 100): string {
  return content.length > maxLength
    ? content.substring(0, maxLength) + "..."
    : content;
}

// PUBLIC_INTERFACE
// Format date for display
function formatDate(date: Date): string {
  return new Intl.DateTimeFormat("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  }).format(date);
}
</script>

<template>
  <div
    class="quicknote-app"
    style="background-color: #ffffff; min-height: 100vh; padding: 2rem"
  >
    <!-- Header -->
    <div class="header" style="margin-bottom: 2rem">
      <h1
        style="
          color: #333;
          font-size: 2.5rem;
          font-weight: bold;
          margin-bottom: 1rem;
          text-align: center;
        "
      >
        📝 QuickNote
      </h1>

      <!-- Search Bar -->
      <div style="max-width: 600px; margin: 0 auto 1.5rem; position: relative">
        <input
          v-model="searchQuery"
          type="text"
          placeholder="Search notes..."
          style="
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #f5f5f5;
            border-radius: 8px;
            font-size: 16px;
            outline: none;
            transition: border-color 0.2s;
          "
          @focus="(e) => (e.target.style.borderColor = '#4a90e2')"
          @blur="(e) => (e.target.style.borderColor = '#f5f5f5')"
        />
        <div
          style="
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
          "
        >
          🔍
        </div>
      </div>

      <!-- Add Note Button -->
      <div style="text-align: center">
        <button
          style="
            background-color: #4a90e2;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 24px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s;
            box-shadow: 0 2px 4px rgba(74, 144, 226, 0.2);
          "
          @click="showAddNoteForm"
          @mouseover="(e) => (e.target.style.backgroundColor = '#357abd')"
          @mouseout="(e) => (e.target.style.backgroundColor = '#4a90e2')"
        >
          ➕ Add Note
        </button>
      </div>
    </div>

    <!-- Notes Grid -->
    <div
      v-if="filteredNotes.length > 0"
      class="notes-grid"
      style="
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 1.5rem;
        max-width: 1200px;
        margin: 0 auto;
      "
    >
      <div
        v-for="note in filteredNotes"
        :key="note.id"
        class="note-card"
        style="
          background-color: #f5f5f5;
          border-radius: 12px;
          padding: 1.5rem;
          box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
          transition: transform 0.2s, box-shadow 0.2s;
          cursor: pointer;
        "
        @mouseover="
          (e) => {
            e.currentTarget.style.transform = 'translateY(-2px)';
            e.currentTarget.style.boxShadow = '0 4px 16px rgba(0,0,0,0.15)';
          }
        "
        @mouseout="
          (e) => {
            e.currentTarget.style.transform = 'translateY(0)';
            e.currentTarget.style.boxShadow = '0 2px 8px rgba(0,0,0,0.1)';
          }
        "
        @click="editNote(note)"
      >
        <div
          style="
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
          "
        >
          <h3
            style="
              color: #333;
              font-size: 1.25rem;
              font-weight: 600;
              margin: 0;
              flex: 1;
              line-height: 1.3;
            "
          >
            {{ note.title }}
          </h3>
          <button
            style="
              background: none;
              border: none;
              color: #ff4757;
              cursor: pointer;
              padding: 4px;
              border-radius: 4px;
              transition: background-color 0.2s;
            "
            title="Delete note"
            @click.stop="deleteNote(note.id)"
            @mouseover="
              (e) => (e.target.style.backgroundColor = 'rgba(255, 71, 87, 0.1)')
            "
            @mouseout="(e) => (e.target.style.backgroundColor = 'transparent')"
          >
            🗑️
          </button>
        </div>

        <p style="color: #666; margin: 0 0 1rem 0; line-height: 1.5">
          {{ getContentSnippet(note.content) }}
        </p>

        <div style="color: #999; font-size: 0.875rem">
          {{ formatDate(note.updatedAt) }}
        </div>
      </div>
    </div>

    <!-- Empty State -->
    <div
      v-else-if="!searchQuery"
      style="text-align: center; margin-top: 4rem; color: #666"
    >
      <div style="font-size: 4rem; margin-bottom: 1rem">📝</div>
      <h3 style="font-size: 1.5rem; margin-bottom: 1rem">No notes yet</h3>
      <p style="font-size: 1rem; margin-bottom: 2rem">
        Create your first note to get started!
      </p>
      <button
        style="
          background-color: #4a90e2;
          color: white;
          border: none;
          border-radius: 8px;
          padding: 12px 24px;
          font-size: 16px;
          cursor: pointer;
        "
        @click="showAddNoteForm"
      >
        Create Note
      </button>
    </div>

    <!-- No Search Results -->
    <div v-else style="text-align: center; margin-top: 4rem; color: #666">
      <div style="font-size: 3rem; margin-bottom: 1rem">🔍</div>
      <h3 style="font-size: 1.5rem; margin-bottom: 1rem">No notes found</h3>
      <p style="font-size: 1rem">Try a different search term</p>
    </div>

    <!-- Add/Edit Note Modal -->
    <div
      v-if="showAddForm"
      style="
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: rgba(0, 0, 0, 0.5);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 1000;
        padding: 2rem;
      "
      @click.self="hideForm"
    >
      <div
        style="
          background-color: white;
          border-radius: 12px;
          padding: 2rem;
          width: 100%;
          max-width: 600px;
          max-height: 80vh;
          overflow-y: auto;
        "
      >
        <h2 style="color: #333; font-size: 1.5rem; margin-bottom: 1.5rem">
          {{ editingNote ? "Edit Note" : "Add New Note" }}
        </h2>

        <div style="margin-bottom: 1rem">
          <label
            style="
              display: block;
              color: #333;
              font-weight: 600;
              margin-bottom: 0.5rem;
            "
          >
            Title
          </label>
          <input
            v-model="newNoteTitle"
            type="text"
            placeholder="Enter note title..."
            style="
              width: 100%;
              padding: 12px;
              border: 2px solid #f5f5f5;
              border-radius: 8px;
              font-size: 16px;
              outline: none;
              transition: border-color 0.2s;
            "
            @focus="(e) => (e.target.style.borderColor = '#4a90e2')"
            @blur="(e) => (e.target.style.borderColor = '#f5f5f5')"
          />
        </div>

        <div style="margin-bottom: 2rem">
          <label
            style="
              display: block;
              color: #333;
              font-weight: 600;
              margin-bottom: 0.5rem;
            "
          >
            Content
          </label>
          <textarea
            v-model="newNoteContent"
            placeholder="Write your note here..."
            rows="8"
            style="
              width: 100%;
              padding: 12px;
              border: 2px solid #f5f5f5;
              border-radius: 8px;
              font-size: 16px;
              outline: none;
              transition: border-color 0.2s;
              resize: vertical;
              font-family: inherit;
            "
            @focus="(e) => (e.target.style.borderColor = '#4a90e2')"
            @blur="(e) => (e.target.style.borderColor = '#f5f5f5')"
          ></textarea>
        </div>

        <div style="display: flex; gap: 1rem; justify-content: flex-end">
          <button
            style="
              background-color: #f5f5f5;
              color: #666;
              border: none;
              border-radius: 8px;
              padding: 10px 20px;
              font-size: 14px;
              cursor: pointer;
              transition: background-color 0.2s;
            "
            @click="hideForm"
            @mouseover="(e) => (e.target.style.backgroundColor = '#e0e0e0')"
            @mouseout="(e) => (e.target.style.backgroundColor = '#f5f5f5')"
          >
            Cancel
          </button>
          <button
            :disabled="!newNoteTitle.trim() || !newNoteContent.trim()"
            style="
              background-color: #4a90e2;
              color: white;
              border: none;
              border-radius: 8px;
              padding: 10px 20px;
              font-size: 14px;
              cursor: pointer;
              transition: background-color 0.2s;
            "
            :style="
              !newNoteTitle.trim() || !newNoteContent.trim()
                ? 'opacity: 0.5; cursor: not-allowed;'
                : ''
            "
            @click="saveNote"
            @mouseover="
              (e) => {
                if (newNoteTitle.trim() && newNoteContent.trim())
                  e.target.style.backgroundColor = '#357abd';
              }
            "
            @mouseout="
              (e) => {
                if (newNoteTitle.trim() && newNoteContent.trim())
                  e.target.style.backgroundColor = '#4a90e2';
              }
            "
          >
            {{ editingNote ? "Update" : "Save" }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.quicknote-app {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen,
    Ubuntu, Cantarell, sans-serif;
}

.note-card {
  position: relative;
}

.note-card:hover {
  transform: translateY(-2px);
}

/* Responsive design */
@media (max-width: 768px) {
  .notes-grid {
    grid-template-columns: 1fr !important;
    gap: 1rem !important;
  }

  .quicknote-app {
    padding: 1rem !important;
  }
}
</style>
