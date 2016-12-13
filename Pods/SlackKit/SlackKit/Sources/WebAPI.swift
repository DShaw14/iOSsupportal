//
// WebAPI.swift
//
// Copyright © 2016 Peter Zignego. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

internal enum Endpoint: String {
    
    case apiTest = "api.test"
    case authRevoke = "auth.revoke"
    case authTest = "auth.test"
    case channelsHistory = "channels.history"
    case channelsInfo = "channels.info"
    case channelsList = "channels.list"
    case channelsMark = "channels.mark"
    case channelsSetPurpose = "channels.setPurpose"
    case channelsSetTopic = "channels.setTopic"
    case chatDelete = "chat.delete"
    case chatPostMessage = "chat.postMessage"
    case chatMeMessage = "chat.meMessage"
    case chatUpdate = "chat.update"
    case dndInfo = "dnd.info"
    case dndTeamInfo = "dnd.teamInfo"
    case emojiList = "emoji.list"
    case filesCommentsAdd = "files.comments.add"
    case filesCommentsEdit = "files.comments.edit"
    case filesCommentsDelete = "files.comments.delete"
    case filesDelete = "files.delete"
    case filesInfo = "files.info"
    case filesUpload = "files.upload"
    case groupsClose = "groups.close"
    case groupsHistory = "groups.history"
    case groupsInfo = "groups.info"
    case groupsList = "groups.list"
    case groupsMark = "groups.mark"
    case groupsOpen = "groups.open"
    case groupsSetPurpose = "groups.setPurpose"
    case groupsSetTopic = "groups.setTopic"
    case imClose = "im.close"
    case imHistory = "im.history"
    case imList = "im.list"
    case imMark = "im.mark"
    case imOpen = "im.open"
    case mpimClose = "mpim.close"
    case mpimHistory = "mpim.history"
    case mpimList = "mpim.list"
    case mpimMark = "mpim.mark"
    case mpimOpen = "mpim.open"
    case oauthAccess = "oauth.access"
    case pinsAdd = "pins.add"
    case pinsRemove = "pins.remove"
    case reactionsAdd = "reactions.add"
    case reactionsGet = "reactions.get"
    case reactionsList = "reactions.list"
    case reactionsRemove = "reactions.remove"
    case rtmStart = "rtm.start"
    case starsAdd = "stars.add"
    case starsRemove = "stars.remove"
    case teamInfo = "team.info"
    case usersGetPresence = "users.getPresence"
    case usersInfo = "users.info"
    case usersList = "users.list"
    case usersSetActive = "users.setActive"
    case usersSetPresence = "users.setPresence"
}

public final class WebAPI {
    
    public typealias FailureClosure = (_ error: SlackError)->Void
    
    public enum InfoType: String {
        case purpose = "purpose"
        case topic = "topic"
    }
    
    public enum ParseMode: String {
        case full = "full"
        case none = "none"
    }
    
    public enum Presence: String {
        case auto = "auto"
        case away = "away"
    }
    
    fileprivate enum ChannelType: String {
        case channel = "channel"
        case group = "group"
        case im = "im"
    }
    
    fileprivate let networkInterface: NetworkInterface
    fileprivate let token: String

    public init(token: String) {
        self.networkInterface = NetworkInterface()
        self.token = token
    }
    
    //MARK: - RTM
    public func rtmStart(_ simpleLatest: Bool? = nil, noUnreads: Bool? = nil, mpimAware: Bool? = nil, success: ((_ response: [String: Any])->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["simple_latest": simpleLatest, "no_unreads": noUnreads, "mpim_aware": mpimAware]
        networkInterface.request(.rtmStart, token: token, parameters: WebAPI.filterNilParameters(parameters), successClosure: {
                (response) -> Void in
                success?(response)
            }) {(error) -> Void in
                failure?(error)
            }
    }
    
    //MARK: - Auth
    public func authenticationTest(_ success: ((_ authenticated: Bool)->Void)?, failure: FailureClosure?) {
        networkInterface.request(.authTest, token: token, parameters: nil, successClosure: {
            (response) -> Void in
                success?(true)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public static func oauthAccess(_ clientID: String, clientSecret: String, code: String, redirectURI: String? = nil, success: ((_ response: [String: Any])->Void)?, failure: ((SlackError)->Void)?) {
        let parameters: [String: Any?] = ["client_id": clientID, "client_secret": clientSecret, "code": code, "redirect_uri": redirectURI]
        NetworkInterface().request(.oauthAccess, parameters: filterNilParameters(parameters), successClosure: {
            (response) -> Void in
            success?(response)
        }) {(error) -> Void in
            failure?(error)
        }
    }
    
    public static func oauthRevoke(_ token: String, test: Bool? = nil, success: ((_ revoked:Bool)->Void)?, failure: ((SlackError)->Void)?) {
        let parameters: [String: Any?] = ["token": token, "test": test]
        NetworkInterface().request(.authRevoke, parameters: filterNilParameters(parameters), successClosure: {
            (response) -> Void in
            success?(true)
        }) {(error) -> Void in
            failure?(error)
        }
    }
    
    //MARK: - Channels
    public func channelHistory(_ id: String, latest: String = "\(Date().timeIntervalSince1970)", oldest: String = "0", inclusive: Bool = false, count: Int = 100, unreads: Bool = false, success: ((_ history: History)->Void)?, failure: FailureClosure?) {
        history(.channelsHistory, id: id, latest: latest, oldest: oldest, inclusive: inclusive, count: count, unreads: unreads, success: {
            (history) -> Void in
                success?(history)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func channelInfo(_ id: String, success: ((_ channel: Channel)->Void)?, failure: FailureClosure?) {
        info(.channelsInfo, type:.channel, id: id, success: {
            (channel) -> Void in
                success?(channel)
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    public func channelsList(_ excludeArchived: Bool = false, success: ((_ channels: [[String: Any]]?)->Void)?, failure: FailureClosure?) {
        list(.channelsList, type:.channel, excludeArchived: excludeArchived, success: {
            (channels) -> Void in
                success?(channels)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func markChannel(_ channel: String, timestamp: String, success: ((_ ts: String)->Void)?, failure: FailureClosure?) {
        mark(.channelsMark, channel: channel, timestamp: timestamp, success: {
            (ts) -> Void in
                success?(timestamp)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func setChannelPurpose(_ channel: String, purpose: String, success: ((_ purposeSet: Bool)->Void)?, failure: FailureClosure?) {
        setInfo(.channelsSetPurpose, type: .purpose, channel: channel, text: purpose, success: {
            (purposeSet) -> Void in
                success?(purposeSet)
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    public func setChannelTopic(_ channel: String, topic: String, success: ((_ topicSet: Bool)->Void)?, failure: FailureClosure?) {
        setInfo(.channelsSetTopic, type: .topic, channel: channel, text: topic, success: {
            (topicSet) -> Void in
                success?(topicSet)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    //MARK: - Messaging
    public func deleteMessage(_ channel: String, ts: String, success: ((_ deleted: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["channel": channel, "ts": ts]
        networkInterface.request(.chatDelete, token: token, parameters: parameters, successClosure: { (response) -> Void in
                success?(true)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func sendMessage(_ channel: String, text: String, username: String? = nil, asUser: Bool? = nil, parse: ParseMode? = nil, linkNames: Bool? = nil, attachments: [Attachment?]? = nil, unfurlLinks: Bool? = nil, unfurlMedia: Bool? = nil, iconURL: String? = nil, iconEmoji: String? = nil, success: (((ts: String?, channel: String?))->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["channel": channel, "text": text.slackFormatEscaping, "as_user": asUser, "parse": parse?.rawValue, "link_names": linkNames, "unfurl_links": unfurlLinks, "unfurlMedia": unfurlMedia, "username": username, "icon_url": iconURL, "icon_emoji": iconEmoji, "attachments": encodeAttachments(attachments)]
        networkInterface.request(.chatPostMessage, token: token, parameters: WebAPI.filterNilParameters(parameters), successClosure: {
            (response) -> Void in
                success?((ts: response["ts"] as? String, response["channel"] as? String))
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func sendMeMessage(_ channel: String, text: String, success: (((ts: String?, channel: String?))->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["channel": channel, "text": text.slackFormatEscaping]
        networkInterface.request(.chatMeMessage, token: token, parameters: WebAPI.filterNilParameters(parameters), successClosure: {
            (response) -> Void in
            success?((ts: response["ts"] as? String, response["channel"] as? String))
        }) {(error) -> Void in
            failure?(error)
        }
    }
    
    public func updateMessage(_ channel: String, ts: String, message: String, attachments: [Attachment?]? = nil, parse:ParseMode = .none, linkNames: Bool = false, success: ((_ updated: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["channel": channel, "ts": ts, "text": message.slackFormatEscaping, "parse": parse.rawValue, "link_names": linkNames, "attachments": encodeAttachments(attachments)]
        networkInterface.request(.chatUpdate, token: token, parameters: WebAPI.filterNilParameters(parameters), successClosure: {
            (response) -> Void in
                success?(true)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    //MARK: - Do Not Disturb
    public func dndInfo(_ user: String? = nil, success: ((_ status: DoNotDisturbStatus)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["user": user]
        networkInterface.request(.dndInfo, token: token, parameters: WebAPI.filterNilParameters(parameters), successClosure: {
            (response) -> Void in
                success?(DoNotDisturbStatus(status: response))
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func dndTeamInfo(_ users: [String]? = nil, success: ((_ statuses: [String: DoNotDisturbStatus])->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["users": users?.joined(separator: ",")]
        networkInterface.request(.dndTeamInfo, token: token, parameters: WebAPI.filterNilParameters(parameters), successClosure: {
            (response) -> Void in
                guard let usersDictionary = response["users"] as? [String: Any] else {
                    success?([:])
                    return
                }
                success?(self.enumerateDNDStatuses(usersDictionary))
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    //MARK: - Emoji
    public func emojiList(_ success: ((_ emojiList: [String: Any]?)->Void)?, failure: FailureClosure?) {
        networkInterface.request(.emojiList, token: token, parameters: nil, successClosure: {
            (response) -> Void in
                success?(response["emoji"] as? [String: Any])
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    //MARK: - Files
    public func deleteFile(_ fileID: String, success: ((_ deleted: Bool)->Void)?, failure: FailureClosure?) {
        let parameters = ["file": fileID]
        networkInterface.request(.filesDelete, token: token, parameters: parameters as [String : Any]?, successClosure: {
            (response) -> Void in
                success?(true)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func fileInfo(_ fileID: String, commentCount: Int = 100, totalPages: Int = 1, success: ((_ file: File)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["file": fileID, "count": commentCount, "totalPages": totalPages]
        networkInterface.request(.filesInfo, token: token, parameters: parameters, successClosure: {
            (response) in
                var file = File(file: response["file"] as? [String: Any])
                (response["comments"] as? [[String: Any]])?.forEach { comment in
                    let comment = Comment(comment: comment)
                    if let id = comment.id {
                        file.comments[id] = comment
                    }
                }
                success?(file)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func uploadFile(_ file: Data, filename: String, filetype: String = "auto", title: String? = nil, initialComment: String? = nil, channels: [String]? = nil, success: ((_ file: File)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["filename": filename, "filetype": filetype, "title": title, "initial_comment": initialComment, "channels": channels?.joined(separator: ",")]
        networkInterface.uploadRequest(token, data: file, parameters: WebAPI.filterNilParameters(parameters), successClosure: {
            (response) -> Void in
                success?(File(file: response["file"] as? [String: Any]))
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    //MARK: - File Comments
    public func addFileComment(_ fileID: String, comment: String, success: ((_ comment: Comment)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["file": fileID, "comment": comment.slackFormatEscaping]
        networkInterface.request(.filesCommentsAdd, token: token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(Comment(comment: response["comment"] as? [String: Any]))
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func editFileComment(_ fileID: String, commentID: String, comment: String, success: ((_ comment: Comment)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["file": fileID, "id": commentID, "comment": comment.slackFormatEscaping]
        networkInterface.request(.filesCommentsEdit, token: token, parameters: parameters, successClosure: {
            (response) -> Void in
            success?(Comment(comment: response["comment"] as? [String: Any]))
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func deleteFileComment(_ fileID: String, commentID: String, success: ((_ deleted: Bool?)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["file": fileID, "id": commentID]
        networkInterface.request(.filesCommentsDelete, token: token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(true)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    //MARK: - Groups
    public func closeGroup(_ groupID: String, success: ((_ closed: Bool)->Void)?, failure: FailureClosure?) {
        close(.groupsClose, channelID: groupID, success: {
            (closed) -> Void in
                success?(closed)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func groupHistory(_ id: String, latest: String = "\(Date().timeIntervalSince1970)", oldest: String = "0", inclusive: Bool = false, count: Int = 100, unreads: Bool = false, success: ((_ history: History)->Void)?, failure: FailureClosure?) {
        history(.groupsHistory, id: id, latest: latest, oldest: oldest, inclusive: inclusive, count: count, unreads: unreads, success: {
            (history) -> Void in
                success?(history)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func groupInfo(_ id: String, success: ((_ channel: Channel)->Void)?, failure: FailureClosure?) {
        info(.groupsInfo, type:.group, id: id, success: {
            (channel) -> Void in
                success?(channel)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func groupsList(_ excludeArchived: Bool = false, success: ((_ channels: [[String: Any]]?)->Void)?, failure: FailureClosure?) {
        list(.groupsList, type:.group, excludeArchived: excludeArchived, success: {
            (channels) -> Void in
                success?(channels)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func markGroup(_ channel: String, timestamp: String, success: ((_ ts: String)->Void)?, failure: FailureClosure?) {
        mark(.groupsMark, channel: channel, timestamp: timestamp, success: {
            (ts) -> Void in
                success?(timestamp)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func openGroup(_ channel: String, success: ((_ opened: Bool)->Void)?, failure: FailureClosure?) {
        let parameters = ["channel":channel]
        networkInterface.request(.groupsOpen, token: token, parameters: parameters as [String: Any]?, successClosure: {
            (response) -> Void in
                success?(true)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func setGroupPurpose(_ channel: String, purpose: String, success: ((_ purposeSet: Bool)->Void)?, failure: FailureClosure?) {
        setInfo(.groupsSetPurpose, type: .purpose, channel: channel, text: purpose, success: {
            (purposeSet) -> Void in
                success?(purposeSet)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func setGroupTopic(_ channel: String, topic: String, success: ((_ topicSet: Bool)->Void)?, failure: FailureClosure?) {
        setInfo(.groupsSetTopic, type: .topic, channel: channel, text: topic, success: {
            (topicSet) -> Void in
                success?(topicSet)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    //MARK: - IM
    public func closeIM(_ channel: String, success: ((_ closed: Bool)->Void)?, failure: FailureClosure?) {
        close(.imClose, channelID: channel, success: {
            (closed) -> Void in
                success?(closed)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func imHistory(_ id: String, latest: String = "\(Date().timeIntervalSince1970)", oldest: String = "0", inclusive: Bool = false, count: Int = 100, unreads: Bool = false, success: ((_ history: History)->Void)?, failure: FailureClosure?) {
        history(.imHistory, id: id, latest: latest, oldest: oldest, inclusive: inclusive, count: count, unreads: unreads, success: {
            (history) -> Void in
                success?(history)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func imsList(_ excludeArchived: Bool = false, success: ((_ channels: [[String: Any]]?)->Void)?, failure: FailureClosure?) {
        list(.imList, type:.im, excludeArchived: excludeArchived, success: {
            (channels) -> Void in
                success?(channels)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func markIM(_ channel: String, timestamp: String, success: ((_ ts: String)->Void)?, failure: FailureClosure?) {
        mark(.imMark, channel: channel, timestamp: timestamp, success: {
            (ts) -> Void in
                success?(timestamp)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func openIM(_ userID: String, success: ((_ imID: String?)->Void)?, failure: FailureClosure?) {
        let parameters = ["user": userID]
        networkInterface.request(.imOpen, token: token, parameters: parameters as [String: Any]?, successClosure: {
            (response) -> Void in
                let group = response["channel"] as? [String: Any]
                success?(group?["id"] as? String)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    //MARK: - MPIM
    public func closeMPIM(_ channel: String, success: ((_ closed: Bool)->Void)?, failure: FailureClosure?) {
        close(.mpimClose, channelID: channel, success: {
            (closed) -> Void in
                success?(closed)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func mpimHistory(_ id: String, latest: String = "\(Date().timeIntervalSince1970)", oldest: String = "0", inclusive: Bool = false, count: Int = 100, unreads: Bool = false, success: ((_ history: History)->Void)?, failure: FailureClosure?) {
        history(.mpimHistory, id: id, latest: latest, oldest: oldest, inclusive: inclusive, count: count, unreads: unreads, success: {
            (history) -> Void in
                success?(history)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func mpimsList(_ excludeArchived: Bool = false, success: ((_ channels: [[String: Any]]?)->Void)?, failure: FailureClosure?) {
        list(.mpimList, type:.group, excludeArchived: excludeArchived, success: {
            (channels) -> Void in
                success?(channels)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func markMPIM(_ channel: String, timestamp: String, success: ((_ ts: String)->Void)?, failure: FailureClosure?) {
        mark(.mpimMark, channel: channel, timestamp: timestamp, success: {
            (ts) -> Void in
                success?(timestamp)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func openMPIM(_ userIDs: [String], success: ((_ mpimID: String?)->Void)?, failure: FailureClosure?) {
        let parameters = ["users": userIDs.joined(separator: ",")]
        networkInterface.request(.mpimOpen, token: token, parameters: parameters as [String: Any]?, successClosure: {
            (response) -> Void in
                let group = response["group"] as? [String: Any]
                success?(group?["id"] as? String)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    //MARK: - Pins
    public func pinItem(_ channel: String, file: String? = nil, fileComment: String? = nil, timestamp: String? = nil, success: ((_ pinned: Bool)->Void)?, failure: FailureClosure?) {
        pin(.pinsAdd, channel: channel, file: file, fileComment: fileComment, timestamp: timestamp, success: {
            (ok) -> Void in
                success?(ok)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func unpinItem(_ channel: String, file: String? = nil, fileComment: String? = nil, timestamp: String? = nil, success: ((_ unpinned: Bool)->Void)?, failure: FailureClosure?) {
        pin(.pinsRemove, channel: channel, file: file, fileComment: fileComment, timestamp: timestamp, success: {
            (ok) -> Void in
                success?(ok)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    fileprivate func pin(_ endpoint: Endpoint, channel: String, file: String? = nil, fileComment: String? = nil, timestamp: String? = nil, success: ((_ ok: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["channel": channel, "file": file, "file_comment": fileComment, "timestamp": timestamp]
        networkInterface.request(endpoint, token: token, parameters: WebAPI.filterNilParameters(parameters), successClosure: {
            (response) -> Void in
                success?(true)
            }){(error) -> Void in
                failure?(error)
        }
    }
    
    //MARK: - Reactions
    // One of file, file_comment, or the combination of channel and timestamp must be specified.
    public func addReaction(_ name: String, file: String? = nil, fileComment: String? = nil, channel: String? = nil, timestamp: String? = nil, success: ((_ reacted: Bool)->Void)?, failure: FailureClosure?) {
        react(.reactionsAdd, name: name, file: file, fileComment: fileComment, channel: channel, timestamp: timestamp, success: {
            (ok) -> Void in
                success?(ok)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    // One of file, file_comment, or the combination of channel and timestamp must be specified.
    public func removeReaction(_ name: String, file: String? = nil, fileComment: String? = nil, channel: String? = nil, timestamp: String? = nil, success: ((_ unreacted: Bool)->Void)?, failure: FailureClosure?) {
        react(.reactionsRemove, name: name, file: file, fileComment: fileComment, channel: channel, timestamp: timestamp, success: {
            (ok) -> Void in
                success?(ok)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    fileprivate func react(_ endpoint: Endpoint, name: String, file: String? = nil, fileComment: String? = nil, channel: String? = nil, timestamp: String? = nil, success: ((_ ok: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["name": name, "file": file, "file_comment": fileComment, "channel": channel, "timestamp": timestamp]
        networkInterface.request(endpoint, token: token, parameters: WebAPI.filterNilParameters(parameters), successClosure: {
            (response) -> Void in
                success?(true)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    //MARK: - Stars
    // One of file, file_comment, channel, or the combination of channel and timestamp must be specified.
    public func addStar(_ file: String? = nil, fileComment: String? = nil, channel: String?  = nil, timestamp: String? = nil, success: ((_ starred: Bool)->Void)?, failure: FailureClosure?) {
        star(.starsAdd, file: file, fileComment: fileComment, channel: channel, timestamp: timestamp, success: {
            (ok) -> Void in
                success?(ok)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    // One of file, file_comment, channel, or the combination of channel and timestamp must be specified.
    public func removeStar(_ file: String? = nil, fileComment: String? = nil, channel: String? = nil, timestamp: String? = nil, success: ((_ unstarred: Bool)->Void)?, failure: FailureClosure?) {
        star(.starsRemove, file: file, fileComment: fileComment, channel: channel, timestamp: timestamp, success: {
            (ok) -> Void in
                success?(ok)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    fileprivate func star(_ endpoint: Endpoint, file: String?, fileComment: String?, channel: String?, timestamp: String?, success: ((_ ok: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["file": file, "file_comment": fileComment, "channel": channel, "timestamp": timestamp]
        networkInterface.request(endpoint, token: token, parameters: WebAPI.filterNilParameters(parameters), successClosure: {
            (response) -> Void in
                success?(true)
            }) {(error) -> Void in
                failure?(error)
        }
    }

    
    //MARK: - Team
    public func teamInfo(_ success: ((_ info: [String: Any]?)->Void)?, failure: FailureClosure?) {
        networkInterface.request(.teamInfo, token: token, parameters: nil, successClosure: {
            (response) -> Void in
                success?(response["team"] as? [String: Any])
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    //MARK: - Users
    public func userPresence(_ user: String, success: ((_ presence: String?)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["user": user]
        networkInterface.request(.usersGetPresence, token: token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(response["presence"] as? String)
            }){(error) -> Void in
                failure?(error)
        }
    }
    
    public func userInfo(_ id: String, success: ((_ user: User)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["user": id]
        networkInterface.request(.usersInfo, token: token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(User(user: response["user"] as? [String: Any]))
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func usersList(_ includePresence: Bool = false, success: ((_ userList: [[String: Any]]?)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["presence": includePresence]
        networkInterface.request(.usersList, token: token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(response["members"] as? [[String: Any]])
            }){(error) -> Void in
                failure?(error)
        }
    }
    
    public func setUserActive(_ success: ((_ success: Bool)->Void)?, failure: FailureClosure?) {
        networkInterface.request(.usersSetActive, token: token, parameters: nil, successClosure: {
            (response) -> Void in
                success?(true)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    public func setUserPresence(_ presence: Presence, success: ((_ success: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["presence": presence.rawValue]
        networkInterface.request(.usersSetPresence, token: token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(true)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    //MARK: - Channel Utilities
    fileprivate func close(_ endpoint: Endpoint, channelID: String, success: ((_ closed: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["channel": channelID]
        networkInterface.request(endpoint, token: token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(true)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    fileprivate func history(_ endpoint: Endpoint, id: String, latest: String = "\(Date().timeIntervalSince1970)", oldest: String = "0", inclusive: Bool = false, count: Int = 100, unreads: Bool = false, success: ((_ history: History)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["channel": id, "latest": latest, "oldest": oldest, "inclusive": inclusive, "count": count, "unreads": unreads]
        networkInterface.request(endpoint, token: token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(History(history: response))
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    fileprivate func info(_ endpoint: Endpoint, type: ChannelType, id: String, success: ((_ channel: Channel)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["channel": id]
        networkInterface.request(endpoint, token: token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(Channel(channel: response[type.rawValue] as? [String: Any]))
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    fileprivate func list(_ endpoint: Endpoint, type: ChannelType, excludeArchived: Bool = false, success: ((_ channels: [[String: Any]]?)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["exclude_archived": excludeArchived]
        networkInterface.request(endpoint, token: token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(response[type.rawValue+"s"] as? [[String: Any]])
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    fileprivate func mark(_ endpoint: Endpoint, channel: String, timestamp: String, success: ((_ ts: String)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["channel": channel, "ts": timestamp]
        networkInterface.request(endpoint, token: token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(timestamp)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    fileprivate func setInfo(_ endpoint: Endpoint, type: InfoType, channel: String, text: String, success: ((_ success: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["channel": channel, type.rawValue: text]
        networkInterface.request(endpoint, token: token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(true)
            }) {(error) -> Void in
                failure?(error)
        }
    }
    
    //MARK: - Encode Attachments
    fileprivate func encodeAttachments(_ attachments: [Attachment?]?) -> String? {
        if let attachments = attachments {
            var attachmentArray: [[String: Any]] = []
            for attachment in attachments {
                if let attachment = attachment {
                    attachmentArray.append(attachment.dictionary)
                }
            }
            do {
                let data = try JSONSerialization.data(withJSONObject: attachmentArray, options: [])
                return String(data: data, encoding: String.Encoding.utf8)
            } catch _ {
                
            }
        }
        return nil
    }
    
    //MARK: - Filter Nil Parameters
    internal static func filterNilParameters(_ parameters: [String: Any?]) -> [String: Any] {
        var finalParameters = [String: Any]()
        for (key, value) in parameters {
            if let unwrapped = value {
                finalParameters[key] = unwrapped
            }
        }
        return finalParameters
    }
    
    //MARK: - Enumerate Do Not Disturb Status
    fileprivate func enumerateDNDStatuses(_ statuses: [String: Any]) -> [String: DoNotDisturbStatus] {
        var retVal = [String: DoNotDisturbStatus]()
        for key in statuses.keys {
            retVal[key] = DoNotDisturbStatus(status: statuses[key] as? [String: Any])
        }
        return retVal
    }
}
