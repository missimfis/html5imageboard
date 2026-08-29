document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".flash").forEach((element) => {
    setTimeout(() => element.classList.add("hidden"), 7000);
  });

  const newBoardButton = document.getElementById("new_board_button");
  const newBoardForm = document.getElementById("new_board_form");
  if (newBoardButton && newBoardForm) {
    newBoardButton.addEventListener("click", () => {
      const hidden = newBoardForm.classList.toggle("hidden");
      newBoardButton.textContent = hidden ? "＋ Add Board" : "Cancel";
    });
  }
});