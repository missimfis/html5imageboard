document.addEventListener("DOMContentLoaded", function() {
  const notice = document.getElementById("notice");
  if (notice) {
    setTimeout(() => notice.style.display = "none", 7000);
  }

  const ibButtons = document.querySelectorAll(".ib-button");
  ibButtons.forEach(btn => {
    btn.addEventListener("mouseenter", () => btn.classList.add("ui-state-hover"));
    btn.addEventListener("mouseleave", () => btn.classList.remove("ui-state-hover"));
  });

  const newBoardButton = document.getElementById("new_board_button");
  const newBoardForm = document.getElementById("new_board_form");
  if (newBoardButton && newBoardForm) {
    newBoardButton.addEventListener("click", function() {
      if (newBoardForm.style.display === "none" || newBoardForm.style.display === "") {
        newBoardForm.style.display = "block";
      } else {
        newBoardForm.style.display = "none";
      }
    });
  }

  const boardSubmit = document.getElementById("board_submit");
  if (boardSubmit) {
    boardSubmit.classList.add("ui-button", "ui-widget", "ui-state-default", "ui-corner-all", "ui-button-icon-only");
    boardSubmit.style.cursor = "pointer";
  }

  const newPostButton = document.getElementById("new_post_button");
  const newPostForm = document.getElementById("new_post_form");
  if (newPostButton && newPostForm) {
    let drawBoxInitialized = false;
    newPostButton.addEventListener("click", function() {
      if (newPostForm.style.display === "none" || newPostForm.style.display === "") {
        newPostForm.style.display = "block";
        if (!drawBoxInitialized) {
          initDrawBox();
          drawBoxInitialized = true;
        }
      } else {
        newPostForm.style.display = "none";
      }
    });
  }

  const postSubmit = document.getElementById("post_submit");
  if (postSubmit) {
    postSubmit.classList.add("ui-button", "ui-widget", "ui-state-default", "ui-corner-all", "ui-button-text-icon");
    postSubmit.style.cursor = "pointer";
  }
});
