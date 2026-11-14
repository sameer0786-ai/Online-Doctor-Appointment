
const checkButton = document.getElementById("checkButton");
const statusElement = document.getElementById("status");

checkButton.addEventListener("click", async () => {
    statusElement.textContent = "Checking...";

    try {
        const response = await fetch("/api/health");
        const data = await response.json();

        if (response.ok && data.success) {
            statusElement.textContent =
                "SUCCESS: Server and MySQL are connected!";
        } else {
            statusElement.textContent = "Server check failed.";
        }

    } catch (error) {
        statusElement.textContent =
            "Unable to connect to server.";
    }
});
