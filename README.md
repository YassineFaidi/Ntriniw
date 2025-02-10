<a name="readme-top"></a>

<br />
<div align="center">
  <a href=".">
    <img src="public/img/logo.png" alt="Logo" width="150" height="150">
  </a>

  <h3 align="center">Ntriniw</h3>

  <p align="center">
    A social mobile app for the calisthenics community with Instagram-like features.
    <br />
    <br />
    <a href=".">View Demo</a>
    <a href=".">Report Bug</a>
    <a href=".">Request Feature</a>
  </p>
</div>

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
        <li><a href="#running-the-application">Running the Application</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

## About The Project

![Product Screenshot][product-screenshot]

Ntriniw is a social mobile app dedicated to the calisthenics community, offering Instagram-like features tailored for fitness enthusiasts. It allows users to share workouts, engage with posts, and connect with other athletes.

Key features include:
* **Post sharing** – Users can upload images, videos, and captions about their calisthenics journey.
* **Like & Comment system** – Engage with posts through likes and comments.
* **Follow system** – Stay updated with athletes and fitness influencers.
* **Real-time chat** – Connect and interact with other community members.

This project aims to foster a strong online calisthenics community by providing a platform for sharing progress, motivation, and knowledge.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

* **Flutter** (Frontend)
* **Django** (Backend)
* **MySQL** (Database)
* **Firebase** (Authentication & Storage)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Getting Started

To get a local copy of this project up and running, follow these steps:

### Prerequisites

Ensure you have the following installed:

* **Flutter** (Latest stable version)
* **Django** (Python 3.x required)
* **MySQL Server**
* **Firebase account** (for authentication and media storage)

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/YassineFaidi/Ntriniw.git
   ```
2. Navigate into the project directory:
   ```sh
   cd Ntriniw
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Set up the backend:
   ```sh
   cd backend
   pip install -r requirements.txt
   python manage.py migrate
   python manage.py runserver
   ```

### Running the Application

1. Ensure the Django backend is running:
   ```sh
   python manage.py runserver
   ```
2. Run the Flutter app:
   ```sh
   flutter run
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Usage

* Sign up and create a profile.
* Upload workout images and videos.
* Like and comment on other users' posts.
* Follow other athletes to see their updates.
* Use the chat feature to connect with the community.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Contact

Yassine Faidi: [@my_linkedin](https://www.linkedin.com/in/yassine-faidi-853671247/) - yassinefaidi133@gmail.com

Project Link: [https://github.com/YassineFaidi/Ntriniw.git](https://github.com/YassineFaidi/Ntriniw.git)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

[product-screenshot]: public/img/appimg.png

