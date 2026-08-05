<script setup lang="ts">
import { ref, watch, onBeforeUnmount } from 'vue'
import { useEditor, EditorContent } from '@tiptap/vue-3'
import StarterKit from '@tiptap/starter-kit'
import Link from '@tiptap/extension-link'
import Image from '@tiptap/extension-image'

const props = defineProps<{
  modelValue?: string
  placeholder?: string
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', value: string): void
}>()

const contentHtml = ref(props.modelValue || '')
const mode = ref<'visual' | 'code'>('visual')

const editor = useEditor({
  content: props.modelValue || '',
  extensions: [
    StarterKit,
    Link.configure({
      openOnClick: false,
      HTMLAttributes: {
        class: 'text-primary-600 underline font-medium hover:text-primary-700',
      },
    }),
    Image.configure({
      HTMLAttributes: {
        class: 'my-4 max-w-full h-auto rounded-lg shadow-sm border border-gray-200 dark:border-gray-800',
      },
    }),
  ],
  editorProps: {
    attributes: {
      class: 'p-4 min-h-[260px] max-h-[500px] overflow-y-auto focus:outline-none prose dark:prose-invert max-w-none text-gray-900 dark:text-gray-100 text-sm leading-relaxed',
    },
  },
  onUpdate: () => {
    if (editor.value) {
      const html = editor.value.getHTML()
      contentHtml.value = html
      emit('update:modelValue', html)
    }
  },
})

watch(() => props.modelValue, (newVal) => {
  if (newVal !== undefined && newVal !== contentHtml.value) {
    contentHtml.value = newVal
    if (editor.value && editor.value.getHTML() !== newVal) {
      editor.value.commands.setContent(newVal, { emitUpdate: false })
    }
  }
})

function toggleHeading(level: 1 | 2 | 3) {
  editor.value?.chain().focus().toggleHeading({ level }).run()
}

function setParagraph() {
  editor.value?.chain().focus().setParagraph().run()
}

function toggleBold() {
  editor.value?.chain().focus().toggleBold().run()
}

function toggleItalic() {
  editor.value?.chain().focus().toggleItalic().run()
}

function toggleStrike() {
  editor.value?.chain().focus().toggleStrike().run()
}

function toggleBulletList() {
  editor.value?.chain().focus().toggleBulletList().run()
}

function toggleOrderedList() {
  editor.value?.chain().focus().toggleOrderedList().run()
}

function toggleBlockquote() {
  editor.value?.chain().focus().toggleBlockquote().run()
}

function handleLink() {
  const url = prompt('Enter Hyperlink URL:')
  if (url) {
    editor.value?.chain().focus().setLink({ href: url }).run()
  }
}

function handleImageEmbed() {
  const url = prompt('Enter Image URL to embed:')
  if (url) {
    editor.value?.chain().focus().setImage({ src: url }).run()
  }
}

function handleVideoEmbed() {
  const url = prompt('Enter MP4 Video URL to embed:')
  if (url) {
    const videoHtml = `
      <div class="my-4 rounded-lg overflow-hidden border border-gray-200 dark:border-gray-800">
        <video src="${url}" controls class="w-full h-auto rounded-lg"></video>
      </div>
    `
    editor.value?.chain().focus().insertContent(videoHtml).run()
  }
}

function toggleMode() {
  if (mode.value === 'visual') {
    if (editor.value) {
      contentHtml.value = editor.value.getHTML()
    }
    mode.value = 'code'
  } else {
    if (editor.value) {
      editor.value.commands.setContent(contentHtml.value, { emitUpdate: false })
    }
    mode.value = 'visual'
  }
}

function handleCodeInput() {
  emit('update:modelValue', contentHtml.value)
  if (editor.value) {
    editor.value.commands.setContent(contentHtml.value, { emitUpdate: false })
  }
}

onBeforeUnmount(() => {
  editor.value?.destroy()
})
</script>

<template>
  <div
    class="border border-gray-200 dark:border-gray-800 rounded-lg overflow-hidden bg-white dark:bg-gray-900 transition-colors">
    <!-- Toolbar -->
    <div
      class="flex flex-wrap items-center justify-between gap-1 p-2 bg-gray-50 dark:bg-gray-950 border-b border-gray-200 dark:border-gray-800 text-gray-700 dark:text-gray-300 select-none">
      <div class="flex flex-wrap items-center gap-1">
        <!-- Headings -->
        <UButton size="xs" :color="editor?.isActive('heading', { level: 1 }) ? 'primary' : 'neutral'"
          :variant="editor?.isActive('heading', { level: 1 }) ? 'solid' : 'ghost'" class="font-extrabold text-xs"
          title="Heading 1" @click="toggleHeading(1)">
          H1
        </UButton>
        <UButton size="xs" :color="editor?.isActive('heading', { level: 2 }) ? 'primary' : 'neutral'"
          :variant="editor?.isActive('heading', { level: 2 }) ? 'solid' : 'ghost'" class="font-bold text-xs"
          title="Heading 2" @click="toggleHeading(2)">
          H2
        </UButton>
        <UButton size="xs" :color="editor?.isActive('heading', { level: 3 }) ? 'primary' : 'neutral'"
          :variant="editor?.isActive('heading', { level: 3 }) ? 'solid' : 'ghost'" class="font-semibold text-xs"
          title="Heading 3" @click="toggleHeading(3)">
          H3
        </UButton>
        <UButton size="xs" :color="editor?.isActive('paragraph') ? 'primary' : 'neutral'"
          :variant="editor?.isActive('paragraph') ? 'solid' : 'ghost'" class="text-xs" title="Normal Paragraph"
          @click="setParagraph">
          P
        </UButton>

        <div class="w-px h-4 bg-gray-300 dark:bg-gray-700 mx-1"></div>

        <!-- Inline Formatting -->
        <UButton size="xs" :color="editor?.isActive('bold') ? 'primary' : 'neutral'"
          :variant="editor?.isActive('bold') ? 'solid' : 'ghost'" icon="i-heroicons-bold" title="Bold (B)"
          @click="toggleBold" />
        <UButton size="xs" :color="editor?.isActive('italic') ? 'primary' : 'neutral'"
          :variant="editor?.isActive('italic') ? 'solid' : 'ghost'" icon="i-heroicons-italic" title="Italic (I)"
          @click="toggleItalic" />
        <UButton size="xs" :color="editor?.isActive('strike') ? 'primary' : 'neutral'"
          :variant="editor?.isActive('strike') ? 'solid' : 'ghost'" icon="i-heroicons-strikethrough"
          title="Strikethrough" @click="toggleStrike" />

        <div class="w-px h-4 bg-gray-300 dark:bg-gray-700 mx-1"></div>

        <!-- Lists & Blocks -->
        <UButton size="xs" :color="editor?.isActive('bulletList') ? 'primary' : 'neutral'"
          :variant="editor?.isActive('bulletList') ? 'solid' : 'ghost'" icon="i-heroicons-list-bullet"
          title="Bullet Point List" @click="toggleBulletList" />
        <UButton size="xs" :color="editor?.isActive('orderedList') ? 'primary' : 'neutral'"
          :variant="editor?.isActive('orderedList') ? 'solid' : 'ghost'" icon="i-heroicons-numbered-list"
          title="Numbered List" @click="toggleOrderedList" />
        <UButton size="xs" :color="editor?.isActive('blockquote') ? 'primary' : 'neutral'"
          :variant="editor?.isActive('blockquote') ? 'solid' : 'ghost'"
          icon="i-heroicons-chat-bubble-bottom-center-text" title="Blockquote" @click="toggleBlockquote" />

        <div class="w-px h-4 bg-gray-300 dark:bg-gray-700 mx-1"></div>

        <!-- Embed Media & Links -->
        <UButton size="xs" :color="editor?.isActive('link') ? 'primary' : 'neutral'"
          :variant="editor?.isActive('link') ? 'solid' : 'ghost'" icon="i-heroicons-link" title="Insert Link"
          @click="handleLink" />
        <UButton size="xs" color="neutral" variant="ghost" icon="i-heroicons-photo" title="Insert Image"
          @click="handleImageEmbed" />
        <UButton size="xs" color="neutral" variant="ghost" icon="i-heroicons-video-camera" title="Insert Video"
          @click="handleVideoEmbed" />
      </div>

      <!-- Dual Mode Toggle (Visual vs Raw HTML/Tailwind CSS Source) -->
      <div class="flex items-center gap-2">
        <UBadge v-if="mode === 'code'" color="warning" variant="soft" size="sm">
          HTML / Tailwind Mode
        </UBadge>
        <UButton size="xs" :color="mode === 'code' ? 'primary' : 'neutral'"
          :variant="mode === 'code' ? 'solid' : 'outline'" icon="i-heroicons-code-bracket" @click="toggleMode">
          {{ mode === 'code' ? 'Visual Mode' : 'HTML / Tailwind Source' }}
        </UButton>
      </div>
    </div>

    <!-- TipTap Visual Editor Component -->
    <EditorContent v-show="mode === 'visual'" :editor="editor" />

    <!-- HTML / Tailwind Code Editor View -->
    <div v-show="mode === 'code'" class="p-3 bg-gray-900 text-gray-100 font-mono text-xs">
      <textarea v-model="contentHtml" rows="12"
        class="w-full bg-transparent border-0 text-amber-300 focus:ring-0 focus:outline-none resize-y font-mono"
        placeholder="<div class=&quot;p-4 bg-gray-100 text-slate-800 font-bold rounded-lg&quot;>Custom HTML / Tailwind CSS content...</div>"
        @input="handleCodeInput"></textarea>
      <div class="text-[10px] text-gray-400 mt-1 flex justify-between">
        <span>Write standard HTML tags &amp; Tailwind CSS utility classes directly.</span>
        <span>TipTap + HTML Mode Active</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
:deep(.ProseMirror) {
  outline: none;
}

:deep(.ProseMirror p.is-editor-empty:first-child::before) {
  content: attr(data-placeholder);
  float: left;
  color: #9ca3af;
  pointer-events: none;
  height: 0;
}
</style>
