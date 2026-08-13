import { ref } from "vue";

const isOpen = ref(false);

export function useNewsletterModal() {
  function openModal() {
    isOpen.value = true;
  }

  function closeModal() {
    isOpen.value = false;
    if (import.meta.client) {
      sessionStorage.setItem("newsletter_dismissed", "true");
    }
  }

  function toggleModal() {
    isOpen.value = !isOpen.value;
  }

  return {
    isOpen,
    openModal,
    closeModal,
    toggleModal,
  };
}
