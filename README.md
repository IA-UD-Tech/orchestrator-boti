# orchestrator-boti



## Prerequisites

Before getting started, ensure you have the following installed:

- Install [Homebrew](https://brew.sh/)
- Install [Taskfile](https://taskfile.dev/installation/)

## Installation steps

1. Run
```
task init
```

2. Copy API_URL and anon key from supabase setup or running 
```
supabase status
```

3. Paste supabase url and anon key in .env file in the _backend\_boti_ and in the secrets.toml file in the _frontend\_boti/.streamlit/_ locations.


# **orchestrator-boti**

A streamlined orchestration system for Boti, built with FastAPI, Supabase and Streamlit.

## **Prerequisites**
Before getting started, ensure you have the following installed:

- **[Homebrew](https://brew.sh/):** A package manager for macOS and Linux.
- **[Taskfile](https://taskfile.dev/installation/):** A task runner to simplify command execution.

## **Installation Steps**

### **1. Initialize the Project**
Run the following command to set up the necessary configurations:

```sh
task init
```

### **2. Retrieve Supabase Credentials**
Get the **API URL** and **anonymous key** from your **Supabase setup** by running:

```sh
supabase status
```

### **3. Configure Environment Variables**
Copy the **Supabase URL** and **anonymous key**, then paste them into the required locations:

- **Backend:** Add the credentials to the `.env` file inside the `backend_boti` directory.
- **Frontend:** Place the credentials inside the `secrets.toml` file, located at `frontend_boti/.streamlit/`.

---

## **Next Steps**
Once setup is complete, you can start the services:

- Run the backend:  
  ```sh
  task start
  ```

---

## **Troubleshooting**
- If you encounter any issues with Supabase, verify the status using:
  ```sh
  supabase status
  ```
- Ensure all environment variables are correctly set in `.env` and `secrets.toml`.

---

## **Contributing**
Feel free to submit **issues** or **pull requests** if you’d like to improve this project!

<!-- ---

## **License**
This project is licensed under **[Your License Here]**. -->
