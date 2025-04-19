*** Settings ***
Documentation     Test suite for Super Admin positive scenarios
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           Collections
Library           DateTime
Library           pyotp

*** Variables ***
${BROWSER}        chrome
${URL}            http://localhost:5173
${DELAY}          0.5
${VALID_EMAIL}    admin@example.com
${VALID_PASSWORD}    admin123
${VALID_NAME}     Admin User
${VALID_PHONE}    0812345678
${VALID_POSITION}    System Administrator
${VALID_DEPARTMENT}    IT Department
${VALID_PRIVATE_KEY}    admin123456

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Wait Until Element Is Visible    xpath://input[@type='email']
    Wait Until Element Is Visible    xpath://input[@type='password']
    Wait Until Element Is Visible    xpath://button[contains(text(),'เข้าสู่ระบบ')]

Login As Super Admin
    [Arguments]    ${email}    ${password}    ${private_key}
    Input Text    xpath://input[@type='email']    ${email}
    Input Text    xpath://input[@type='password']    ${password}
    Input Text    xpath://input[@name='privateKey']    ${private_key}
    Click Button    xpath://button[contains(text(),'เข้าสู่ระบบ')]
    Wait Until Element Is Visible    xpath://div[contains(text(),'เข้าสู่ระบบสำเร็จ')]

*** Test Cases ***
TC-001-Add-SuperAdmin
    [Documentation]    Test adding a new super admin
    Open Browser To Login Page
    Login As Super Admin    ${VALID_EMAIL}    ${VALID_PASSWORD}    ${VALID_PRIVATE_KEY}
    Click Element    xpath://button[contains(text(),'จัดการผู้ดูแลระบบ')]
    Wait Until Element Is Visible    xpath://button[contains(text(),'เพิ่มผู้ดูแลระบบ')]
    Click Button    xpath://button[contains(text(),'เพิ่มผู้ดูแลระบบ')]
    Input Text    xpath://input[@name='name']    New Admin
    Input Text    xpath://input[@name='email']    newadmin@example.com
    Input Text    xpath://input[@name='password']    newadmin123
    Input Text    xpath://input[@name='phone']    0898765432
    Input Text    xpath://input[@name='position']    New Position
    Input Text    xpath://input[@name='department']    New Department
    Input Text    xpath://input[@name='privateKey']    newadmin123456
    Click Button    xpath://button[contains(text(),'บันทึก')]
    Wait Until Element Is Visible    xpath://div[contains(text(),'เพิ่มผู้ดูแลระบบสำเร็จ')]
    [Teardown]    Close Browser

TC-002-Edit-SuperAdmin
    [Documentation]    Test editing an existing super admin
    Open Browser To Login Page
    Login As Super Admin    ${VALID_EMAIL}    ${VALID_PASSWORD}    ${VALID_PRIVATE_KEY}
    Click Element    xpath://button[contains(text(),'จัดการผู้ดูแลระบบ')]
    Wait Until Element Is Visible    xpath://tr[contains(.,'newadmin@example.com')]
    Click Element    xpath://tr[contains(.,'newadmin@example.com')]//button[contains(text(),'แก้ไข')]
    Input Text    xpath://input[@name='name']    Updated Admin
    Input Text    xpath://input[@name='position']    Updated Position
    Input Text    xpath://input[@name='department']    Updated Department
    Click Button    xpath://button[contains(text(),'บันทึก')]
    Wait Until Element Is Visible    xpath://div[contains(text(),'แก้ไขข้อมูลสำเร็จ')]
    [Teardown]    Close Browser

TC-003-delete-SuperAdmin
    [Documentation]    Test deleting a super admin
    Open Browser To Login Page
    Login As Super Admin    ${VALID_EMAIL}    ${VALID_PASSWORD}    ${VALID_PRIVATE_KEY}
    Click Element    xpath://button[contains(text(),'จัดการผู้ดูแลระบบ')]
    Wait Until Element Is Visible    xpath://tr[contains(.,'newadmin@example.com')]
    Click Element    xpath://tr[contains(.,'newadmin@example.com')]//button[contains(text(),'ลบ')]
    Click Button    xpath://button[contains(text(),'ยืนยัน')]
    Wait Until Element Is Visible    xpath://div[contains(text(),'ลบผู้ดูแลระบบสำเร็จ')]
    [Teardown]    Close Browser

TC-004-View-SuperAdmin
    [Documentation]    Test viewing super admin list
    Open Browser To Login Page
    Login As Super Admin    ${VALID_EMAIL}    ${VALID_PASSWORD}    ${VALID_PRIVATE_KEY}
    Click Element    xpath://button[contains(text(),'จัดการผู้ดูแลระบบ')]
    Wait Until Element Is Visible    xpath://table
    Wait Until Element Is Visible    xpath://tr[contains(.,'${VALID_EMAIL}')]
    [Teardown]    Close Browser

TC-005-Add-SuperAdmin
    [Documentation]    Test adding another super admin
    Open Browser To Login Page
    Login As Super Admin    ${VALID_EMAIL}    ${VALID_PASSWORD}    ${VALID_PRIVATE_KEY}
    Click Element    xpath://button[contains(text(),'จัดการผู้ดูแลระบบ')]
    Wait Until Element Is Visible    xpath://button[contains(text(),'เพิ่มผู้ดูแลระบบ')]
    Click Button    xpath://button[contains(text(),'เพิ่มผู้ดูแลระบบ')]
    Input Text    xpath://input[@name='name']    Second Admin
    Input Text    xpath://input[@name='email']    secondadmin@example.com
    Input Text    xpath://input[@name='password']    secondadmin123
    Input Text    xpath://input[@name='phone']    0876543210
    Input Text    xpath://input[@name='position']    Second Position
    Input Text    xpath://input[@name='department']    Second Department
    Input Text    xpath://input[@name='privateKey']    secondadmin123456
    Click Button    xpath://button[contains(text(),'บันทึก')]
    Wait Until Element Is Visible    xpath://div[contains(text(),'เพิ่มผู้ดูแลระบบสำเร็จ')]
    [Teardown]    Close Browser

TC-006-Logout
    [Documentation]    Test logging out
    Open Browser To Login Page
    Login As Super Admin    ${VALID_EMAIL}    ${VALID_PASSWORD}    ${VALID_PRIVATE_KEY}
    Click Element    xpath://button[contains(text(),'ออกจากระบบ')]
    Wait Until Element Is Visible    xpath://div[contains(text(),'ออกจากระบบสำเร็จ')]
    [Teardown]    Close Browser 
