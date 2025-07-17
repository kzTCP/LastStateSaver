# Godot Last Session Saver (Plugin for Godot 3.x)

This Godot 3.x plugin allows you to automatically save and restore the last state of the Godot Editor. Improve your workflow by jumping back exactly where you left off — whether you were in a script, a scene, or the AssetLib tab.

---

## 🎥 Demo Video

### 🔁 Before vs After Using the Plugin

> See the difference when the plugin is **disabled vs enabled** — how Godot normally resets vs. how it restores your last session:

[![Before and After Demo](https://img.youtube.com/vi/Sd8PUMxMKSM/0.jpg)](https://www.youtube.com/watch?v=Sd8PUMxMKSM)

---

## ✨ Features

- 🧠 Remembers the last **opened scripts** and **scenes**
- 🗂️ Restores the last **active editor tab**: 2D, 3D, Script, or AssetLib
- 📁 Opens the **last selected file** in the FileSystem (if available)
- 📄 Opens the **last selected script** if  **active editor tab** was selected
- 📂 Automatically opens **folders of scripts** that were previously opened in the **Script Editor**, making navigation easier

## 📢 Notice

- ⚠️ If you close the **main scene**, it may still reopen — this is **Godot’s default behavior**, not controlled by the plugin.  
- ⚠️ If a **scene wasn't saved**, it won't be reopened next time, because **Godot** closes it before the plugin can store its state.  
- 📜 All loaded items are logged into a `log.json` file located at: `res://addons/LastStateSaver/json/log.json`, which is refreshed weekly.
- 📜 After closing **Godot**, a `save.json` file will be created, storing all information for the next session. It is located at: `res://addons/LastStateSaver/json/save.json`


